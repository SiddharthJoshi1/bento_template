import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/theme/theme_flavour.dart';

/// Paints a circle divided into three sectors representing a [ThemeVariant]:
///
///   • accent     — top-right quarter    (25%, 12→3 o'clock)
///   • textColour — bottom-right quarter (25%, 3→6 o'clock)
///   • background — full left half       (50%, 6→12 o'clock)
///
/// Used both in the picker panel (48 px) and the control pill (28 px).
class TriSectorPainter extends CustomPainter {
  const TriSectorPainter({
    required this.background,
    required this.accent,
    required this.textColour,
  });

  final Color background;
  final Color accent;
  final Color textColour;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()..style = PaintingStyle.fill;

    // Accent: 12 o'clock → 3 o'clock
    paint.color = accent;
    canvas.drawArc(rect, -pi / 2, pi / 2, true, paint);

    // Text colour: 3 o'clock → 6 o'clock
    paint.color = textColour;
    canvas.drawArc(rect, 0, pi / 2, true, paint);

    // Background: 6 o'clock → 12 o'clock (left half)
    paint.color = background;
    canvas.drawArc(rect, pi / 2, pi, true, paint);
  }

  @override
  bool shouldRepaint(TriSectorPainter old) =>
      old.background != background ||
      old.accent != accent ||
      old.textColour != textColour;
}

/// A circular swatch that renders the tri-sector [ThemeVariant] preview.
///
/// Shows an animated selection ring when [isSelected] is true.
class FlavourSwatch extends StatelessWidget {
  const FlavourSwatch({
    super.key,
    required this.flavour,
    required this.mode,
    required this.size,
    required this.isSelected,
    required this.onTap,
  });

  final ThemeFlavour flavour;
  final ThemeMode mode;
  final double size;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final variant = flavour.variantFor(mode);

    return Tooltip(
      message: flavour.name,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.onSurface
                  : Colors.transparent,
              width: 2.5,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(isSelected ? 2.5 : 0),
            child: CustomPaint(
              painter: TriSectorPainter(
                background: variant.background,
                accent: variant.accent,
                textColour: variant.textColour,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
