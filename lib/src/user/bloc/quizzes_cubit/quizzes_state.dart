import '../../../common/model/quiz_model.dart';

abstract class QuizzesState {}

class QuizzesInitial extends QuizzesState {}

class QuizzesLoading extends QuizzesState {}

class QuizzesLoaded extends QuizzesState {
  final List<QuizQuestion> quizzes;
  final int currentIndex;
  final int score;
  final double timeLeft;
  final String? selectedAnswer;
  final bool isAnswerSelected;

  QuizzesLoaded({
    required this.quizzes,
    required this.currentIndex,
    required this.score,
    required this.timeLeft,
    this.selectedAnswer,
    required this.isAnswerSelected,
  });
}

class QuizzesFinished extends QuizzesState {
  final int score;
  final int total;

  QuizzesFinished({required this.score, required this.total});
}
