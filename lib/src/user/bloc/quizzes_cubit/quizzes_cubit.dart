import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../user/bloc/quizzes_cubit/quizzes_state.dart';

import '../../../common/model/quiz_model.dart';

class QuizzesCubit extends Cubit<QuizzesState> {
  QuizzesCubit() : super(QuizzesInitial());

  List<QuizQuestion> _quizzes = [];
  int _currentIndex = 0;
  int _score = 0;
  double _timeLeft = 20000;
  bool _isAnswerSelected = false; // Yangi flag qo'shildi

  String? _selectedAnswer;
  Timer? _timer;

  void loadQuizzes() {
    emit(QuizzesLoading());
    _quizzes = $footballQuizzes;
    _currentIndex = 0;
    _score = 0;
    _timeLeft = 20000;
    _selectedAnswer = null;
    _isAnswerSelected = false;
    _startTimer();
    emit(QuizzesLoaded(
      quizzes: _quizzes,
      currentIndex: _currentIndex,
      score: _score,
      timeLeft: _timeLeft,
      isAnswerSelected: _isAnswerSelected,
    ));
  }

  void selectAnswer(String answer) {
    if (_selectedAnswer != null) return;
    _selectedAnswer = answer;
    _isAnswerSelected = true; // Javob tanlandi
    bool isCorrect = answer == _quizzes[_currentIndex].correctAnswer;
    if (isCorrect) _score++;

    emit(QuizzesLoaded(
      quizzes: _quizzes,
      currentIndex: _currentIndex,
      score: _score,
      timeLeft: _timeLeft,
      selectedAnswer: _selectedAnswer,
      isAnswerSelected: _isAnswerSelected,
    ));
  }

  void nextQuestion({bool isTimeOver = false}) {
    if (!isTimeOver && !_isAnswerSelected) return;

    if (_currentIndex < _quizzes.length - 1) {
      _currentIndex++;
      _selectedAnswer = null;
      _isAnswerSelected = false;
      _startTimer();
      emit(QuizzesLoaded(
        quizzes: _quizzes,
        currentIndex: _currentIndex,
        score: _score,
        timeLeft: _timeLeft,
        isAnswerSelected: _isAnswerSelected,
      ));
    } else {
      _timer?.cancel();
      emit(QuizzesFinished(score: _score, total: _quizzes.length));
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 20000;
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_timeLeft > 0) {
        _timeLeft -= 100;
        emit(QuizzesLoaded(
          quizzes: _quizzes,
          currentIndex: _currentIndex,
          score: _score,
          timeLeft: _timeLeft,
          selectedAnswer: _selectedAnswer,
          isAnswerSelected: _isAnswerSelected,
        ));
      } else {
        _timer?.cancel();
        nextQuestion(
            isTimeOver: true); // Timer tugaganda keyingi savolga o'tadi
      }
    });
  }
}
