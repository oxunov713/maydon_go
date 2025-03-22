import 'package:flutter/widgets.dart';
import '../l10n/app_localizations.dart';
import '../model/time_slot_model.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get lan => AppLocalizations.of(this)!;
}

extension GroupByDateExtension on List<TimeSlot> {
  Map<String, List<TimeSlot>> groupByDate() {
    final Map<String, List<TimeSlot>> groupedSlots = {};
    for (final slot in this) {
      final date = slot.startTime!.toIso8601String().split('T')[0];
      if (groupedSlots[date] == null) {
        groupedSlots[date] = [];
      }
      groupedSlots[date]!.add(slot);
    }
    return groupedSlots;
  }
}
