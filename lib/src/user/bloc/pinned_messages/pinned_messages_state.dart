class PinnedMessagesState {
  final bool isExpanded;
  final int activeIndex;

  const PinnedMessagesState({
    this.isExpanded = false,
    this.activeIndex = 0,
  });

  PinnedMessagesState copyWith({
    bool? isExpanded,
    int? activeIndex,
  }) {
    return PinnedMessagesState(
      isExpanded: isExpanded ?? this.isExpanded,
      activeIndex: activeIndex ?? this.activeIndex,
    );
  }
}