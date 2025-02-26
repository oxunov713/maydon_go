class TimeSlot {
  final DateTime? startTime;
  final DateTime? endTime;

  TimeSlot({this.startTime, this.endTime});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: json['startTime'] != null
          ? DateTime.tryParse(json['startTime'])
          : null,
      endTime: json['endTime'] != null
          ? DateTime.tryParse(json['endTime'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TimeSlot &&
              runtimeType == other.runtimeType &&
              startTime == other.startTime &&
              endTime == other.endTime;

  @override
  int get hashCode => startTime.hashCode ^ endTime.hashCode;
}