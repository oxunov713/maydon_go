import '../../../common/model/quiz_model.dart';

abstract class QuizzesState {
  const QuizzesState();
}

class QuizzesInitial extends QuizzesState {
  const QuizzesInitial();
}

class QuizzesLoading extends QuizzesState {
  const QuizzesLoading();
}

class QuizzesLoaded extends QuizzesState {
  final List<QuizPack> quizPacks;
  const QuizzesLoaded({required this.quizPacks});
}

class QuizPackLoading extends QuizzesState {
  const QuizPackLoading();
}

class QuizPackLoaded extends QuizzesState {
  final QuizPack quizPack;
  const QuizPackLoaded({required this.quizPack});
}

class QuizInProgress extends QuizzesState {
  final QuizPack quizPack;
  final Quiz currentQuiz;
  final int currentQuestionIndex;
  final int totalQuestions;
  final int timeLeft;
  final int totalTime;
  final Answer? selectedAnswer;
  final Map<int, Answer> selectedAnswers;

  QuizInProgress({
    required this.quizPack,
    required this.currentQuiz,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.timeLeft,
    required this.totalTime,
    required this.selectedAnswer,
    required this.selectedAnswers,
  });

  QuizInProgress copyWith({
    QuizPack? quizPack,
    Quiz? currentQuiz,
    int? currentQuestionIndex,
    int? totalQuestions,
    int? timeLeft,
    int? totalTime,
    Answer? selectedAnswer,
    Map<int, Answer>? selectedAnswers,
  }) {
    return QuizInProgress(
      quizPack: quizPack ?? this.quizPack,
      currentQuiz: currentQuiz ?? this.currentQuiz,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      timeLeft: timeLeft ?? this.timeLeft,
      totalTime: totalTime ?? this.totalTime,
      selectedAnswer: selectedAnswer,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
    );
  }
}

class QuizFinished extends QuizzesState {
  final QuizPack quizPack;
  final int correctAnswers;
  final int totalQuestions;
  final String difficulty;
  final double difficultyMultiplier;
  final int earnedCoins;

  const QuizFinished({
    required this.quizPack,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.difficulty,
    required this.difficultyMultiplier,
    required this.earnedCoins,
  });
}

class QuizzesError extends QuizzesState {
  final String message;
  const QuizzesError({required this.message});
}
