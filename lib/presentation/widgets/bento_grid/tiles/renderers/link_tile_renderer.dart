
import 'package:flutter/material.dart';

import '../../../../../core/injector.dart';
import '../../../../../domain/entities/link.dart';
import '../../../../../domain/entities/tile_config.dart';
import '../../../../../domain/repos/link_repo.dart';
import '../../../../extensions/colour_extension.dart';
import '../../../../extensions/url_extension.dart';
import '../../../../utils/app_styles.dart';
import '../../../../utils/icon_mapping.dart';
import '../../../../utils/tile_constants.dart';
import '../../../../utils/tile_image.dart';

class LinkTileRenderer extends StatelessWidget {
  final TileConfig config;
  final Color backgroundColour;

  const LinkTileRenderer({
    super.key,
    required this.config,
    required this.backgroundColour,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColour = backgroundColour.contrastingTextColour;

    if (config.isTower) return _buildTowerLayout(context, textColour);
    if (config.isBar) return _buildBarLayout(context, textColour);
    return _buildCardLayout(context, textColour);
  }

  // Tall tiles — icon + title stacked vertically, image below
  Widget _buildTowerLayout(BuildContext context, Color textColour) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, textColour: textColour),
        const Spacer(),
        if (config.imagePath != null)
          Expanded(
            flex: 4,
            child: _buildImageCard(backgroundColour, AppRadii.card),
          ),
      ],
    );
  }

  // Card tiles — icon + title left, image right
  Widget _buildCardLayout(BuildContext context, Color textColour) {
    return Row(
      children: [
        Expanded(flex: 4, child: _buildHeader(context, textColour: textColour)),
        if (config.imagePath != null)
          Expanded(
            flex: 4,
            child: _buildImageCard(backgroundColour, AppRadii.chip),
          ),
      ],
    );
  }

  // Bar tiles — icon + title inline, arrow at end
  Widget _buildBarLayout(BuildContext context, Color textColour) {
    return Row(
      children: [
        Expanded(
          child: _buildHeader(
            context,
            textColour: textColour,
            sideBySide: true,
          ),
        ),
        if (config.url != null)
          Icon(Icons.arrow_outward, size: AppIconSizes.s, color: textColour),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required Color textColour,
    bool sideBySide = false,
  }) {
    final linkEntity = locator<LinkRepository>().getLinkData(config.url ?? '');
    final captionColour = textColour.withValues(alpha: 0.55);
    final iconCard = _buildIconCard(linkEntity);

    if (sideBySide) {
      return Row(
        children: [
          iconCard,
          TileSpacing.horizontalSmall,
          if (config.title != null && config.title!.isNotEmpty)
            Expanded(
              child: Text(
                config.title!,
                maxLines: 1,
                style: ResponsiveText.labelLarge(context)?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColour,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        iconCard,
        TileSpacing.small,
        if (config.title != null && config.title!.isNotEmpty)
          Text(
            config.title!,
            maxLines: 2,
            style:
                (Breakpoints.isNarrow(context)
                        ? ResponsiveText.labelSmall(context)
                        : ResponsiveText.labelMedium(context))
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColour,
                      overflow: TextOverflow.ellipsis,
                    ),
          ),

        if (!Breakpoints.isNarrow(context)) ...[
          TileSpacing.tiny,
          Text(
            config.url?.getBasePath() ?? "",
            style: ResponsiveText.caption(
              context,
            )?.copyWith(color: captionColour),
          ),
        ],
      ],
    );
  }

  Widget _buildIconCard(LinkConfig linkEntity) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppRadii.chip),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppInsets.s),
        child: Icon(
          LinkIconMapping.getIcon(linkEntity.linkIcon),
          color: linkEntity.brandColour.toColour(),
          size: AppIconSizes.m,
        ),
      ),
    );
  }

  Widget _buildImageCard(Color colour, BorderRadius radius) {
    return Card(
      color: colour,
      clipBehavior: Clip.hardEdge,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black12),
        borderRadius: radius,
      ),
      child: TileImage(path: config.imagePath!),
    );
  }
}
