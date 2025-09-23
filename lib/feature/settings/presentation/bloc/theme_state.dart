import 'package:flutter/material.dart';
import 'package:wedlist/feature/settings/domain/entities/theme_entity.dart';

class ThemeState {

  ThemeState(this.appTheme, this.themeData);
  final AppTheme appTheme;
  final ThemeData themeData;
}
