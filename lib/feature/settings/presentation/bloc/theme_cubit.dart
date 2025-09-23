import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/config/theme/theme_data.dart';
import 'package:wedlist/config/theme/theme_repository.dart';
import 'package:wedlist/feature/settings/domain/entities/theme_entity.dart';
import 'package:wedlist/feature/settings/domain/usecases/toggle_theme.dart';
import 'package:wedlist/feature/settings/presentation/bloc/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this.themeRepository, this.toggleTheme)
    : super(ThemeState(AppTheme.light, AppThemes.lightTheme)) {
    _loadSavedTheme(); // Kaydedilen temayı başlangıçta yükle
  }
  final ThemeRepository themeRepository; // ✅ Doğrudan repo kullanacağız
  final ToggleTheme toggleTheme;

  Future<void> _loadSavedTheme() async {
    final savedTheme = await themeRepository
        .loadTheme(); // ✅ Doğrudan çağırıyoruz
    emit(
      ThemeState(
        savedTheme,
        savedTheme == AppTheme.dark
            ? AppThemes.darkTheme
            : AppThemes.lightTheme,
      ),
    );
  }

  Future<void> toggle() async {
    final newTheme = await toggleTheme(state.appTheme);
    emit(
      ThemeState(
        newTheme,
        newTheme == AppTheme.dark ? AppThemes.darkTheme : AppThemes.lightTheme,
      ),
    );
  }
}
