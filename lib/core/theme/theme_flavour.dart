import 'package:flutter/material.dart';

/// A single colour palette definition for one brightness mode.
class ThemeVariant {
  const ThemeVariant({
    required this.background,
    required this.accent,
    required this.textColour,
  });

  /// Scaffold / page background — 50% of the swatch circle.
  final Color background;

  /// Primary accent for buttons, highlights — 25% of the swatch circle.
  final Color accent;

  /// Default body text colour — 25% of the swatch circle.
  final Color textColour;
}

/// A named flavour pairing a [light] and [dark] variant.
///
/// Toggling the theme mode switches between the two variants of the same
/// flavour, keeping the user's palette choice consistent across modes.
class ThemeFlavour {
  const ThemeFlavour({
    required this.id,
    required this.name,
    required this.light,
    required this.dark,
  });

  /// Stable identifier used for persistence.
  final String id;

  /// Human-readable label shown beneath the swatch.
  final String name;

  /// Colours used in light mode.
  final ThemeVariant light;

  /// Colours used in dark mode.
  final ThemeVariant dark;

  /// Returns the correct [ThemeVariant] for [mode].
  ThemeVariant variantFor(ThemeMode mode) =>
      mode == ThemeMode.light ? light : dark;
}

/// Registry of all available theme flavours.
///
/// Add new entries here — nothing else needs to change.
class ThemeFlavours {
  ThemeFlavours._();

  static const List<ThemeFlavour> all = [
    // 1 — Chalk: crisp white light / deep charcoal dark
    ThemeFlavour(
      id: 'chalk',
      name: 'Chalk',
      light: ThemeVariant(
        background: Color(0xFFFFFFFF),
        accent: Color(0xFF1A1A1A),
        textColour: Color(0xFF1A1A1A),
      ),
      dark: ThemeVariant(
        background: Color(0xFF181818),
        accent: Color(0xFFF0F0F0),
        textColour: Color(0xFFE8E8E8),
      ),
    ),

    // 2 — Dusk: warm cream light / indigo-tinged dark
    ThemeFlavour(
      id: 'dusk',
      name: 'Dusk',
      light: ThemeVariant(
        // CHANGED: From warm cream (FDF6EC) to a cool, pale lavender/indigo
        background: Color(0xFFF4F2FA),
        accent: Color(0xFF7C6AF7),
        textColour: Color(0xFF2D2040),
      ),
      dark: ThemeVariant(
        background: Color(0xFF13101F),
        accent: Color(0xFF9D8FFF),
        textColour: Color(0xFFE4DFFF),
      ),
    ),

    // 3 — Espresso: earthy tan light / dark espresso
    ThemeFlavour(
      id: 'espresso',
      name: 'Espresso',
      light: ThemeVariant(
        background: Color(0xFFF5ECD7),
        accent: Color(0xFFB87333),
        textColour: Color(0xFF2C1A0E),
      ),
      dark: ThemeVariant(
        background: Color(0xFF1C1208),
        accent: Color(0xFFD4924A),
        textColour: Color(0xFFEEDFC0),
      ),
    ),

    // 4 — Forest: soft sage light / deep pine dark
    ThemeFlavour(
      id: 'forest',
      name: 'Forest',
      light: ThemeVariant(
        background: Color(0xFFF0F5EE),
        accent: Color(0xFF3A7D44),
        textColour: Color(0xFF1A2E1C),
      ),
      dark: ThemeVariant(
        background: Color(0xFF111A12),
        accent: Color(0xFF5FAD56),
        textColour: Color(0xFFCDE8C5),
      ),
    ),

    // 5 — Rose: blush light / dark burgundy
    ThemeFlavour(
      id: 'rose',
      name: 'Rose',
      light: ThemeVariant(
        background: Color(0xFFFDF0F3),
        accent: Color(0xFFE8476A),
        textColour: Color(0xFF2D0A14),
      ),
      dark: ThemeVariant(
        background: Color(0xFF1A080D),
        accent: Color(0xFFFF6B8A),
        textColour: Color(0xFFFFDDE4),
      ),
    ),

    // 6 — Slate: cool grey light / deep navy dark
    ThemeFlavour(
      id: 'slate',
      name: 'Slate',
      light: ThemeVariant(
        // Darkened from a near-white (F2F4F7) to a true light slate grey
        background: Color(0xFFE2E7ED),
        // Darkened and muted from a bright blue to a deep steel/slate blue
        accent: Color(0xFF2E558A),
        textColour: Color(0xFF0D1B2E),
      ),
      dark: ThemeVariant(
        // Slightly shifted to feel more like a dark stone/charcoal navy
        background: Color(0xFF0F1722),
        // Softened from a bright sky blue to a muted slate-blue
        accent: Color(0xFF648CB4),
        textColour: Color(0xFFCDD6E8),
      ),
    ),
  ];

  static ThemeFlavour byId(String id) =>
      all.firstWhere((f) => f.id == id, orElse: () => all.first);
}
