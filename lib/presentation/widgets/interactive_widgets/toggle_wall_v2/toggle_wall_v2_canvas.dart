import 'package:flutter/material.dart';
import '../../../extensions/colour_extension.dart';

class ToggleWallV2Canvas extends StatefulWidget {
  const ToggleWallV2Canvas({
    super.key,
    required this.columns,
    required this.rows,
    required this.bgColor,
    required this.neonColors,
    required this.glowIntensity,
  });

  final int columns;
  final int rows;
  final String bgColor;
  final List<String> neonColors;
  final double glowIntensity;

  @override
  State<ToggleWallV2Canvas> createState() => _ToggleWallV2CanvasState();
}

class _ToggleWallV2CanvasState extends State<ToggleWallV2Canvas> {
  late List<bool> _states;

  @override
  void initState() {
    super.initState();
    _states = List.filled(widget.columns * widget.rows, false);
  }

  @override
  void didUpdateWidget(ToggleWallV2Canvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newCount = widget.columns * widget.rows;
    if (_states.length != newCount) {
      _states = List.filled(newCount, false);
    }
  }

  Color _neonColorFor(int index) {
    final hex = widget.neonColors[index % widget.neonColors.length];
    return hex.toColour();
  }

  void _toggle(int index) {
    setState(() => _states[index] = !_states[index]);
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.bgColor.toColour();

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final gapW = 8.0;
          final gapH = 8.0;
          final cellW = (constraints.maxWidth -
                  (widget.columns - 1) * gapW) /
              widget.columns;
          final cellH = (constraints.maxHeight -
                  (widget.rows - 1) * gapH) /
              widget.rows;

          return Wrap(
            spacing: gapW,
            runSpacing: gapH,
            children: List.generate(widget.columns * widget.rows, (i) {
              final neon = _neonColorFor(i);
              final isOn = _states[i];

              return _NeonCell(
                width: cellW,
                height: cellH,
                neonColor: neon,
                isOn: isOn,
                glowIntensity: widget.glowIntensity,
                onTap: () => _toggle(i),
              );
            }),
          );
        },
      ),
    );
  }
}

class _NeonCell extends StatefulWidget {
  const _NeonCell({
    required this.width,
    required this.height,
    required this.neonColor,
    required this.isOn,
    required this.glowIntensity,
    required this.onTap,
  });

  final double width;
  final double height;
  final Color neonColor;
  final bool isOn;
  final double glowIntensity;
  final VoidCallback onTap;

  @override
  State<_NeonCell> createState() => _NeonCellState();
}

class _NeonCellState extends State<_NeonCell> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final intensity = widget.glowIntensity;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
          width: widget.width,
          height: widget.height,
          transform: _hovered
              ? (Matrix4.identity()..scaleByDouble(1.05, 1.05, 1.0, 1.0))
              : Matrix4.identity(),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.isOn
                ? widget.neonColor.withValues(alpha: 0.08)
                : const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.isOn ? widget.neonColor : const Color(0xFF2A2A4A),
              width: 1,
            ),
          ),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isOn ? widget.neonColor : const Color(0xFF333333),
                boxShadow: widget.isOn
                    ? [
                        BoxShadow(
                          color: widget.neonColor.withValues(alpha: 0.9),
                          blurRadius: 8 * intensity,
                        ),
                        BoxShadow(
                          color: widget.neonColor.withValues(alpha: 0.6),
                          blurRadius: 20 * intensity,
                        ),
                        BoxShadow(
                          color: widget.neonColor.withValues(alpha: 0.3),
                          blurRadius: 40 * intensity,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
