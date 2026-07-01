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

  void _setHovered(bool value) {
    if (_isHovered != value) setState(() => _isHovered = value);
  }

  void _setPressed(bool value) {
    if (_isPressed != value) setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) return widget.child;

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : (_isHovered ? 1.02 : 1.0),
          duration: const Duration(milliseconds: AnimationConstants.tileScaleDuration),
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}
