
import 'package:flutter/material.dart';

/// Apple-style pulsing blue location dot.
///
/// Two staggered rings scale outward and fade, with a white-bordered
/// blue dot in the centre — matching the iOS Maps / Find My aesthetic.
class PulsingLocationDot extends StatefulWidget {
  const PulsingLocationDot({super.key});

  @override
  State<PulsingLocationDot> createState() => _PulsingLocationDotState();
}

class _PulsingLocationDotState extends State<PulsingLocationDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Ring 1 — leads
  late final Animation<double> _ring1Scale;
  late final Animation<double> _ring1Opacity;

  // Ring 2 — follows with a 0.4s delay
  late final Animation<double> _ring2Scale;
  late final Animation<double> _ring2Opacity;

  static const _dotColour = Color(0xFF2A7FE8);
  static const _ringColour = Color(0xFF378ADD);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Defer start by one frame so the animation doesn't compete with
    // the scroll gesture that brought this tile into view.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.repeat();
    });

    // Ring 1: full cycle
    _ring1Scale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );
    _ring1Opacity = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    // Ring 2: starts at 40% through the cycle
    _ring2Scale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
    _ring2Opacity = Tween<double>(begin: 0.4, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SizedBox.expand(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ring 2 (behind ring 1)
              _buildRing(_ring2Scale.value, _ring2Opacity.value),
              // Ring 1
              _buildRing(_ring1Scale.value, _ring1Opacity.value),
              // White border
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
              // Blue dot
              Container(
                width: 13,
                height: 13,
                decoration: const BoxDecoration(
                  color: _dotColour,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRing(double scale, double opacity) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Container(
        width: 60 * scale,
        height: 60 * scale,
        decoration: BoxDecoration(
          color: _ringColour,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}