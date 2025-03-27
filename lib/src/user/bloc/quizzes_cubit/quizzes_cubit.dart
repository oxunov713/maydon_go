import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/quiz_model.dart';
import 'quizzes_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizState());

  Future<void> fetchQuizzes() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final quizzes = <Quiz>[];
      emit(state.copyWith(quizzes: quizzes, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: 'Xatolik yuz berdi: $e', isLoading: false));
    }
  }
}
