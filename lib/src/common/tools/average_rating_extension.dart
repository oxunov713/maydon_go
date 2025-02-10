extension AverageRating on List<int> {
  get average {
    if (isEmpty) return 0;
    return (reduce((a, b) => a + b) / length).toStringAsFixed(1);
  }
}
