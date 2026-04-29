import 'package:flutter/material.dart';

import '../../../../../domain/entities/tile_config.dart';
import '../../../../extensions/colour_extension.dart';
import '../../../../utils/app_styles.dart';
import '../../../../utils/tile_constants.dart';

class TextTileRenderer extends StatelessWidget {
  final TileConfig config;

  const TextTileRenderer({super.key, required this.config});

  Color get _backgroundColour =>
      config.colour != null ? config.colour!.toColour() : Colors.white;

  @override
  Widget build(BuildContext context) {
    final textColor = _backgroundColour.contrastingTextColour;
    return config.isBar
        ? _buildBarLayout(context, textColor)
        : _buildCardLayout(context, textColor);
  }

  // Bar tiles — single line title with optional arrow
  Widget _buildBarLayout(BuildContext context, Color textColor) {
    return Padding(
      padding: TilePadding.horizontal,
      child: Row(
        children: [
          if (config.title != null && config.title!.isNotEmpty)
            Expanded(
              child: Text(
                config.title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ResponsiveText.caption(
                  context,
                )?.copyWith(fontWeight: FontWeight.w600, color: textColor),
              ),
            ),
          if (config.url != null)
            Icon(
              Icons.arrow_outward_sharp,
              size: AppIconSizes.s,
              color: textColor,
            ),
        ],
      ),
    );
  }

  // Card/tower tiles — decorative icon at top, italic body text at bottom
  Widget _buildCardLayout(BuildContext context, Color textColor) {
    return Padding(
      padding: TilePadding.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.bubble_chart_outlined,
            size: AppIconSizes.l,
            color: textColor,
          ),
          if (config.title != null && config.title!.isNotEmpty)
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  config.title!,
                  style: _getTextStyle(context, textColor),
                ),
              ),
            ),
        ],
      ),
    );
  }

  TextStyle _getTextStyle(BuildContext context, Color textColor) {
    if (Breakpoints.isTablet(context)) {
      return ResponsiveText.titleMedium(context)!.copyWith(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600,
        color: textColor,
      );
    } else {
      return ResponsiveText.titleSmall(context)!.copyWith(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600,
        color: textColor,
        overflow: TextOverflow.fade,
      );
    }
  }
}
