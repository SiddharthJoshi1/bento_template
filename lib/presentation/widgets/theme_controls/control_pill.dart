import 'package:flutter/material.dart';

import '../../../../core/theme/theme_flavour.dart';
import 'flavour_swatch.dart';

/// Pill-shaped floating button that shows the current theme mode icon and
/// the active flavour swatch. Tapping the icon toggles light/dark; tapping
/// the swatch opens the theme picker panel.
class ControlPill extends StatelessWidget {
  const ControlPill({
    super.key,
    required this.isDark,
    required this.activeFlavour,
    required this.activeMode,
    required this.onToggle,
    required this.onPickerTap,
  });

  final bool isDark;
  final ThemeFlavour activeFlavour;
  final ThemeMode activeMode;
  final VoidCallback onToggle;
  final VoidCallback onPickerTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(50),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Light / dark mode toggle
            IconButton(
              iconSize: 20,
              tooltip: isDark ? 'Switch to light' : 'Switch to dark',
              onPressed: onToggle,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  key: ValueKey(isDark),
                ),
              ),
            ),
            const SizedBox(width: 2),
            // Active flavour mini-swatch — opens the picker panel
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: FlavourSwatch(
                flavour: activeFlavour,
                mode: activeMode,
                size: 28,
                isSelected: false,
                onTap: onPickerTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
