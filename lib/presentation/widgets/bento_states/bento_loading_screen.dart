import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';


/// Full-screen loading state — a 4×4 bento grid pulsing in a staggered wave.
///
/// Each tile's animation is offset by [_staggerMs] × its index, creating a
/// left-to-right, top-to-bottom ripple across the grid.
class BentoLoadingScreen extends StatefulWidget {
  const BentoLoadingScreen({super.key});

  @override
  State<BentoLoadingScreen> createState() => _BentoLoadingScreenState();
}

class _BentoLoadingScreenState extends State<BentoLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const int _tileCount = 16;
  static const double _tileSize = 56.0;
  static const double _gap = 10.0;
  static const int _staggerMs = 100;
  static const int _durationMs = 1600;

  // One animation per tile, staggered via Interval.
  late final List<Animation<double>> _opacities;
  late final List<Animation<double>> _scales;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _durationMs),
    )..repeat();

    _opacities = List.generate(_tileCount, (i) {
      final start = (i * _staggerMs) / _durationMs;
      // Clamp so the last tile still completes within one cycle.
      final end = (start + 0.5).clamp(0.0, 1.0);
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.2),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 0.2, end: 1.0),
          weight: 50,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });

    _scales = List.generate(_tileCount, (i) {
      final start = (i * _staggerMs) / _durationMs;
      final end = (start + 0.5).clamp(0.0, 1.0);
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.88),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 0.88, end: 1.0),
          weight: 50,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gridSize = _tileSize * 4 + _gap * 3;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return SizedBox(
                  width: gridSize,
                  height: gridSize,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: _gap,
                      mainAxisSpacing: _gap,
                    ),
                    itemCount: _tileCount,
                    itemBuilder: (context, i) {
                      return Transform.scale(
                        scale: _scales[i].value,
                        child: Opacity(
                          opacity: _opacities[i].value,
                          child: _BentoTileShape(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Loading',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
                    letterSpacing: 0.08,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BentoTileShape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppInsets.m),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.25),
          width: 0.5,
        ),
      ),
    );
  }
}
