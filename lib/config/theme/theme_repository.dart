// ignore_for_file: avoid-unused-parameters

import 'package:wedlist/feature/settings/domain/entities/theme_entity.dart';

class ThemeRepository {
  // ignore: public_member_api_docs, no-empty-block
  Future<void> saveTheme(AppTheme theme) async {}
  Future<AppTheme> loadTheme() async {
    return AppTheme.light; // Default to light theme
  }
}
