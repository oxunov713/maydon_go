import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maydon_go/src/common/service/api/api_client.dart';
import 'package:maydon_go/src/common/service/api/common_service.dart';
import 'package:maydon_go/src/common/service/api/user_service.dart';
import '../../../common/model/quiz_model.dart';
import 'quizzes_state.dart';

class QuizPackCubit extends Cubit<QuizzesState> {
  QuizPackCubit() : super(QuizzesInitial());

  Timer? _questionTimer;
  final  _apiService = CommonService(ApiClient().dio);
  late int userId;

  Future<void> fetchQuizzes() async {
    emit(QuizzesLoading());
    try {
      final List<QuizPack> quizPacks = await _apiService.getQuizWithPacks();
      emit(QuizzesLoaded(quizPacks: quizPacks));
    } catch (e) {
      emit(QuizzesError(message: 'Error fetching quizzes: $e'));
    }
  }

  Future<void> loadQuizPack({
    required int quizPackId,
    required int userId,
  }) async {
    emit(QuizPackLoading());
    try {
      final quizPack = await _apiService.getQuizPack(quizPackId: quizPackId);
      this.userId = userId;
      emit(QuizPackLoaded(quizPack: quizPack));
    } catch (e) {
      emit(QuizzesError(message: 'Error loading quiz pack: $e'));
    }
  }

  Future<void> startQuiz() async {
    if (state is! QuizPackLoaded) return;

    final quizPack = (state as QuizPackLoaded).quizPack;
    if (quizPack.quizzes.isEmpty) {
      emit(QuizzesError(message: 'No questions in this quiz pack'));
      return;
    }

    emit(QuizInProgress(
      quizPack: quizPack,
      currentQuiz: quizPack.quizzes.first,
      currentQuestionIndex: 0,
      totalQuestions: quizPack.quizzes.length,
      timeLeft: 30000,
      totalTime: 30000,
      selectedAnswer: null,
      selectedAnswers: {},
    ));

    _startQuestionTimer(quizPack);
  }

  void selectAnswer(Answer answer) {
    if (state is! QuizInProgress) return;

    final currentState = state as QuizInProgress;

    if (currentState.selectedAnswer != null) return;

    emit(currentState.copyWith(
      selectedAnswer: answer,
      selectedAnswers: {
        ...currentState.selectedAnswers,
        currentState.currentQuestionIndex: answer,
      },
    ));

    _questionTimer?.cancel();
  }

  void moveToNextQuestion(QuizPack quizPack) {
    if (state is! QuizInProgress) return;

    final currentState = state as QuizInProgress;
    final nextIndex = currentState.currentQuestionIndex + 1;

    _questionTimer?.cancel();

    if (nextIndex < currentState.totalQuestions) {
      emit(currentState.copyWith(
        currentQuiz: quizPack.quizzes[nextIndex],
        currentQuestionIndex: nextIndex,
        timeLeft: 30000,
        selectedAnswer: null,
      ));
      _startQuestionTimer(quizPack);
    } else {
      _finishQuiz(quizPack);
    }
  }

  void _finishQuiz(QuizPack quizPack) async {
    if (state is! QuizInProgress) return;

    final currentState = state as QuizInProgress;
    int correctAnswers = 0;

    currentState.selectedAnswers.forEach((index, answer) {
      if (answer != null) {
        final question = quizPack.quizzes[index];
        if (question.answers
            .any((a) => a.answerText == answer.answerText && a.correct)) {
          correctAnswers++;
        }
      }
    });

    // Coinsni hisoblash uchun yagona funksiya chaqiriladi
    final coins = calculateCoins(
        correctAnswers, currentState.totalQuestions, quizPack.difficultyLevel);

    await UserService(ApiClient().dio).addCoinsToUser(userId, coins);

    emit(QuizFinished(
      quizPack: quizPack,
      correctAnswers: correctAnswers,
      totalQuestions: currentState.totalQuestions,
      difficulty: quizPack.difficultyLevel ?? 'Easy',
      difficultyMultiplier:
          _getMultiplierForDifficulty(quizPack.difficultyLevel),
      earnedCoins: coins,
    ));
  }

  // Bir xil formulani qo'llash uchun
  int calculateReward(QuizPack pack) {
    return calculateCoins(
        pack.quizzes.length, pack.quizzes.length, pack.difficultyLevel);
  }

  int calculateCoins(
      int correctAnswers, int totalQuestions, String? difficultyLevel) {
    final multiplier = _getMultiplierForDifficulty(difficultyLevel);

    return (correctAnswers * 5000 * multiplier).toInt();
  }

  double _getMultiplierForDifficulty(String? difficulty) {
    switch (difficulty?.toLowerCase()) {
      case 'easy':
        return 1;
      case 'medium':
        return 2;
      case 'hard':
        return 3;
      default:
        return 1;
    }
  }

  void _startQuestionTimer(QuizPack quizPack) {
    _questionTimer?.cancel();

    _questionTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (state is! QuizInProgress) {
        timer.cancel();
        return;
      }

      final currentState = state as QuizInProgress;
      final newTimeLeft = currentState.timeLeft - 100;

      if (newTimeLeft > 0) {
        emit(currentState.copyWith(timeLeft: newTimeLeft));
      } else {
        timer.cancel();
        moveToNextQuestion(quizPack);
      }
    });
  }

  @override
  Future<void> close() {
    _questionTimer?.cancel();
    return super.close();
  }
}
