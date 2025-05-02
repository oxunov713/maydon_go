import 'main_model.dart';

class TimeSlot {
  final DateTime? startTime;
  final DateTime? endTime;

  TimeSlot({this.startTime, this.endTime});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: json['startTime'] != null
          ? DateTime.tryParse(json['startTime'])
          : null,
      endTime:
          json['endTime'] != null ? DateTime.tryParse(json['endTime']) : null,
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

class BronModel {
  final int id;
  final TimeSlot timeSlot;
  final UserModel user;

  BronModel({required this.id, required this.timeSlot, required this.user});

  factory BronModel.fromJson(Map<String, dynamic> json) {
    return BronModel(
      id: json['id'],
      timeSlot: TimeSlot.fromJson(json),
      user: UserModel.fromJson(json['user']),
    );
  }
}
