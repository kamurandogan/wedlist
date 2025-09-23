import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/feature/settings/domain/entities/theme_entity.dart';
import 'package:wedlist/feature/settings/presentation/bloc/theme_cubit.dart';
import 'package:wedlist/feature/settings/presentation/bloc/theme_state.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, theme) {
        return Switch(
          value: theme.appTheme == AppTheme.dark,
          onChanged: (_) => context.read<ThemeCubit>().toggle(),
        );
      },
    );
  }
}
