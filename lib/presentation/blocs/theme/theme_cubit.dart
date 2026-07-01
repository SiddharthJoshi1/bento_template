import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/theme_flavour.dart';

part 'theme_state.dart';

class _Keys {
  static const String isDark = 'theme_is_dark';
  static const String flavourId = 'theme_flavour_id';
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState()) {
    _loadFromPrefs();
  }

  void toggleTheme() {
    final newMode =
        state.mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(state.copyWith(mode: newMode));
    _saveToPrefs();
  }

  void setFlavour(ThemeFlavour flavour) {
    emit(state.copyWith(flavourId: flavour.id));
    _saveToPrefs();
  }

  /// Applies the content.json theme as the initial default. Only takes
  /// effect if the user hasn't previously saved a theme preference.
  /// Skips the emit if the resulting state would be identical.
  Future<void> applyContentDefault({
    String? flavourId,
    String? themeMode,
  }) async {
    if (flavourId == null && themeMode == null) return;

    final prefs = await SharedPreferences.getInstance();
    final hasUserPreference = prefs.containsKey(_Keys.isDark) ||
        prefs.containsKey(_Keys.flavourId);
    if (hasUserPreference) return;

    final mode = switch (themeMode) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => null,
    };

    final newState = state.copyWith(
      flavourId: flavourId,
      mode: mode,
    );

    if (newState != state) emit(newState);
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_Keys.isDark) ?? false;
    final id = prefs.getString(_Keys.flavourId) ?? 'chalk';

    emit(ThemeState(
      mode: isDark ? ThemeMode.dark : ThemeMode.light,
      flavourId: id,
    ));
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_Keys.isDark, state.mode == ThemeMode.dark);
    await prefs.setString(_Keys.flavourId, state.flavourId);
  }
}
