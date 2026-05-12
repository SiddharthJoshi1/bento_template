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
  List<bool> _states = const [];
  int _lastCount = 0;

  static const double _gap = 8.0;
  static const double _minCellSize = 28.0;
  static const double _padding = 20.0;

  Color _neonColorFor(int index) {
    final hex = widget.neonColors[index % widget.neonColors.length];
    return hex.toColour();
  }

  void _toggle(int index) {
    if (index < 0 || index >= _states.length) return;
    setState(() => _states[index] = !_states[index]);
  }

  void _resizeStates(int newCount) {
    if (newCount == _lastCount) return;
    _lastCount = newCount;
    // Preserve existing on-states for cells that still exist.
    final next = List.filled(newCount, false);
    for (var i = 0; i < newCount && i < _states.length; i++) {
      next[i] = _states[i];
    }
    _states = next;
  }

  int _computeColumns(double availableWidth) {
    for (int cols = widget.columns; cols >= 1; cols--) {
      final cellW = (availableWidth - (cols - 1) * _gap) / cols;
      if (cellW >= _minCellSize) return cols;
    }
    return 1;
  }

  int _computeRows(double availableHeight) {
    for (int rows = widget.rows; rows >= 1; rows--) {
      final cellH = (availableHeight - (rows - 1) * _gap) / rows;
      if (cellH >= _minCellSize) return rows;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.bgColor.toColour();

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(_padding),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // constraints is already the inner size after Container padding.
          final cols = _computeColumns(constraints.maxWidth);
          final rows = _computeRows(constraints.maxHeight);
          final count = cols * rows;

          _resizeStates(count);

          final cellW = (constraints.maxWidth - (cols - 1) * _gap) / cols;
          final cellH = (constraints.maxHeight - (rows - 1) * _gap) / rows;

          return Wrap(
            spacing: _gap,
            runSpacing: _gap,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children: List.generate(count, (i) {
              return _NeonCell(
                width: cellW,
                height: cellH,
                neonColor: _neonColorFor(i),
                isOn: _states[i],
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
              width: (widget.width * 0.35).clamp(8.0, 20.0),
              height: (widget.height * 0.35).clamp(8.0, 20.0),
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
