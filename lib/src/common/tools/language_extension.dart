import 'package:flutter/widgets.dart';
import '../l10n/app_localizations.dart';
import '../model/time_slot_model.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get lan => AppLocalizations.of(this)!;
}

extension GroupByDateExtension on List<TimeSlot> {
  Map<String, List<TimeSlot>> groupByDate() {
    Map<String, List<TimeSlot>> grouped = {};
    for (var slot in this) {
      String dateKey = slot.startTime!.toIso8601String().split('T')[0]; // YYYY-MM-DD
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(slot);
    }
    return grouped;
  }
}
