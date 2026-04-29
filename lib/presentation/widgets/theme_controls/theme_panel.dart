import 'package:bento_template/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme_flavour.dart';
import 'flavour_swatch.dart';

/// Floating card that displays all available [ThemeFlavours] as
/// [FlavourSwatch] circles for the user to choose from.
///
/// Tapping a swatch calls [onFlavourSelected] and should close the panel.
class ThemePanel extends StatelessWidget {
  const ThemePanel({
    super.key,
    required this.activeId,
    required this.activeMode,
    required this.onFlavourSelected,
  });

  final String activeId;
  final ThemeMode activeMode;
  final ValueChanged<ThemeFlavour> onFlavourSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.card),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Theme',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: ThemeFlavours.all.map((flavour) {
                    return FlavourSwatch(
                      flavour: flavour,
                      mode: activeMode,
                      size: 48,
                      isSelected: flavour.id == activeId,
                      onTap: () => onFlavourSelected(flavour),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
