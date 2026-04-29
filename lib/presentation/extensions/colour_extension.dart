import 'package:flutter/material.dart';

extension ColourBrightness on Color {
  /// True when this colour is dark enough to warrant white text on top.
  bool get isDark => computeLuminance() < 0.5;

  /// Returns [Colors.white] or [Colors.black] — whichever is more
  /// readable as text on top of this colour.
  Color get contrastingTextColour => isDark ? Colors.white : Colors.black;
}

extension ColourConverter on String {
  /// Converts string like "#E1306C" to Color(0xFFE1306C)
  Color toColour() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Color toSuperLightColour() {
    final hsl = HSLColor.fromColor(toColour());

    // We keep the Hue and Saturation, but set Lightness to 95%
    // clamp(0.0, 1.0) ensures we don't crash if the math goes weird
    final lightHsl = hsl.withLightness(0.90.clamp(0.0, 1.0));

    return lightHsl.toColor();
  }
}
