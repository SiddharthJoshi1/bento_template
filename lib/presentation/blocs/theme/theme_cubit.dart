import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/theme_flavour.dart';

part 'theme_state.dart';

class _Keys {
  static const String isDark = 'theme_is_dark';
  static const String flavourId = 'theme_flavour_id';
}

/// Cubit that owns the app theme — brightness mode + active flavour.
///
/// Toggling the mode switches between the light and dark variant of the
/// same flavour, so the palette choice stays consistent.
///
/// Usage:
/// ```dart
/// context.read<ThemeCubit>().toggleTheme();
/// context.read<ThemeCubit>().setFlavour(ThemeFlavours.byId('dusk'));
/// ```
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState()) {
    _loadFromPrefs();
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Toggles between light and dark mode, keeping the active flavour the same.
  void toggleTheme() {
    final newMode =
        state.mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(state.copyWith(mode: newMode));
    _saveToPrefs();
  }

  /// Switches to [flavour], keeping the current brightness mode.
  void setFlavour(ThemeFlavour flavour) {
    emit(state.copyWith(flavourId: flavour.id));
    _saveToPrefs();
  }

  // ---------------------------------------------------------------------------
  // Persistence
  // ---------------------------------------------------------------------------

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
