import 'package:bento_template/core/constants.dart';
import 'package:flutter/material.dart';

class BentoInteractionEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const BentoInteractionEffect({super.key, required this.child, this.onTap});

  @override
  State<BentoInteractionEffect> createState() => _BentoInteractionEffectState();
}

class _BentoInteractionEffectState extends State<BentoInteractionEffect> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // If no tap handler, don't show pointer or animate
    if (widget.onTap == null) return widget.child;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          // Logic: Squish when clicked (0.98), Scale up when hovered (1.02), else normal (1.0)
          scale: _isPressed ? 0.98 : (_isHovered ? 1.02 : 1.0),
          duration: const Duration(milliseconds: AnimationConstants.tileScaleDuration),
          curve: Curves.easeOutCubic, // The "Bento" springy feel
          child: widget.child,
        ),
      ),
    );
  }
}
