import 'package:flutter/material.dart';
import '../interactive_widget.dart';
import 'toggle_wall_v2_canvas.dart';

class ToggleWallV2Widget extends InteractiveWidget {
  const ToggleWallV2Widget();

  @override
  String get widgetId => 'toggle_wall_v2';

  @override
  String get displayName => 'Toggle Wall';

  @override
  String get description =>
      'A neon light panel of glowing toggle bulbs on a dark background.';

  @override
  List<String> get tags => ['fidget', 'interactive', 'neon', 'toggle'];

  @override
  Widget buildWithConfig(Map<String, dynamic> config, {String? colour}) {
    final columns = config['columns'] as int? ?? 4;
    final rows = config['rows'] as int? ?? 6;
    final bgColor = config['bg_color'] as String? ?? '#0F0F1A';
    final neonColors = (config['neon_colors'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const [
          '#00F0FF',
          '#FF006E',
          '#39FF14',
          '#FFD600',
          '#BF00FF',
          '#FF4500',
        ];
    final glowIntensity = (config['glow_intensity'] as num?)?.toDouble() ?? 1.0;

    return ToggleWallV2Canvas(
      columns: columns,
      rows: rows,
      bgColor: bgColor,
      neonColors: neonColors,
      glowIntensity: glowIntensity,
    );
  }
}
