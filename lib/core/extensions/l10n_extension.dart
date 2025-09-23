import 'package:flutter/widgets.dart';
import 'package:wedlist/generated/l10n/app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
}
