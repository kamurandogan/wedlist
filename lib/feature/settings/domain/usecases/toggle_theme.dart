import 'dart:core';

import 'package:wedlist/feature/settings/data/theme_repository_impl.dart';
import 'package:wedlist/feature/settings/domain/entities/theme_entity.dart';

class ToggleTheme {
  ToggleTheme(this.repository);
  final ThemeRepositoryImpl repository;

  Future<AppTheme> call(AppTheme currentTheme) async {
    final newTheme = currentTheme == AppTheme.dark ? AppTheme.light : AppTheme.dark;
    await repository.saveTheme(newTheme);
    return newTheme;
  }
}
