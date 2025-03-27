import '../../../common/model/quiz_model.dart';

class QuizState {
  final bool isLoading;
  final List<Quiz> quizzes;
  final String? error;

  QuizState({this.isLoading = false, this.quizzes = const [], this.error});

  QuizState copyWith({bool? isLoading, List<Quiz>? quizzes, String? error}) {
    return QuizState(
      isLoading: isLoading ?? this.isLoading,
      quizzes: quizzes ?? this.quizzes,
      error: error,
    );
  }
}