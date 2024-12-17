import 'package:flutter/widgets.dart';
import '../l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get lan => AppLocalizations.of(this)!;
}
