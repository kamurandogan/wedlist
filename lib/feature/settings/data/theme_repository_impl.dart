import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedlist/config/theme/theme_repository.dart';
import 'package:wedlist/feature/settings/domain/entities/theme_entity.dart';

final class ThemeRepositoryImpl implements ThemeRepository {
  ThemeRepositoryImpl(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  @override
  Future<AppTheme> loadTheme() async {
    final isDark = sharedPreferences.getBool('isDarkTheme') ?? false;
    debugPrint("Mevcut tema: ${isDark ? 'Koyu' : 'Açık'}");
    return isDark ? AppTheme.dark : AppTheme.light;
  }

  @override
  Future<void> saveTheme(AppTheme theme) async {
    final isDarkTheme = theme == AppTheme.dark;
    await sharedPreferences.setBool('isDarkTheme', isDarkTheme);
    debugPrint("Tema kaydedildi: ${isDarkTheme ? 'Koyu' : 'Açık'}");
  }
}
