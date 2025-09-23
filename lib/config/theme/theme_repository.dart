import 'package:wedlist/feature/settings/domain/entities/theme_entity.dart';

class ThemeRepository {
  Future<void> saveTheme(AppTheme theme) async {}
  Future<AppTheme> loadTheme() async {
    return AppTheme.light; // Default to light theme
  }
}
