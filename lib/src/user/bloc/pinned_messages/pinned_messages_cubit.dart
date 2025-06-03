import 'package:flutter_bloc/flutter_bloc.dart';

import 'pinned_messages_state.dart';

class PinnedMessagesCubit extends Cubit<PinnedMessagesState> {
  PinnedMessagesCubit() : super(const PinnedMessagesState());

  void toggleExpanded() {
    emit(state.copyWith(isExpanded: !state.isExpanded));
  }

  void changeIndex(int index) {
    emit(state.copyWith(activeIndex: index));
  }

  void reset() {
    emit(const PinnedMessagesState());
  }
}