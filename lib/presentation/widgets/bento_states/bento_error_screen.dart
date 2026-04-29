import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Full-screen error state — a faded 4×4 bento grid with a sad face overlay.
class BentoErrorScreen extends StatelessWidget {
  const BentoErrorScreen({super.key, required this.message});

  final String message;

  static const double _tileSize = 56.0;
  static const double _gap = 10.0;

  @override
  Widget build(BuildContext context) {
    final gridSize = _tileSize * 4 + _gap * 3;
    final errorColour = Theme.of(context).colorScheme.error;
    final surfaceColour =
        Theme.of(context).colorScheme.surfaceContainerHighest;
    final outlineColour =
        Theme.of(context).colorScheme.outline.withValues(alpha: 0.25);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: gridSize,
              height: gridSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Faded grid behind the face.
                  Opacity(
                    opacity: 0.25,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: _gap,
                        mainAxisSpacing: _gap,
                      ),
                      itemCount: 16,
                      itemBuilder: (_, _) => DecoratedBox(
                        decoration: BoxDecoration(
                          color: surfaceColour,
                          borderRadius:
                              BorderRadius.circular(AppInsets.m),
                          border: Border.all(
                            color: outlineColour,
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Sad face.
                  CustomPaint(
                    size: const Size(88, 88),
                    painter: _SadFacePainter(colour: errorColour),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'The bento couldn\'t load',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Draws a sad face: circle outline, two dot eyes, downward arc mouth.
class _SadFacePainter extends CustomPainter {
  const _SadFacePainter({required this.colour});

  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    final strokePaint = Paint()
      ..color = colour
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = colour
      ..style = PaintingStyle.fill;

    // Outer circle.
    canvas.drawCircle(Offset(cx, cy), r - 1.5, strokePaint);

    // Eyes — two filled circles.
    canvas.drawCircle(Offset(cx - r * 0.32, cy - r * 0.2), r * 0.09, fillPaint);
    canvas.drawCircle(Offset(cx + r * 0.32, cy - r * 0.2), r * 0.09, fillPaint);

    // Sad mouth — arc curving downward (upside-down smile).
    final mouthRect = Rect.fromCenter(
      center: Offset(cx, cy + r * 0.38),
      width: r * 0.9,
      height: r * 0.45,
    );
    canvas.drawArc(mouthRect, 0, 3.14159, false, strokePaint);
  }

  @override
  bool shouldRepaint(_SadFacePainter old) => old.colour != colour;
}
