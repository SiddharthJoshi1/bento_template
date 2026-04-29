import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/injector.dart';
import '../../../../domain/entities/tile_config.dart';
import '../../../../domain/repos/analytics_repo.dart';
import '../../../../domain/repos/link_repo.dart';
import '../../../extensions/colour_extension.dart';
import '../../../utils/tile_constants.dart';
import 'mouse_hover_effect.dart';
import 'renderers/image_tile_renderer.dart';
import 'renderers/link_tile_renderer.dart';
import 'renderers/map_tile_renderer.dart';
import 'renderers/section_title_renderer.dart';
import 'renderers/text_tile_renderer.dart';
import 'renderers/interactive_widget_tile_renderer.dart';
import 'renderers/video_tile_renderer.dart';

/// A factory widget that delegates rendering to the appropriate tile renderer
/// based on [TileConfig.type]. Each renderer is responsible for its own layout.
class SmartBentoTile extends StatelessWidget {
  final TileConfig config;

  const SmartBentoTile({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final backgroundColour = _getBackgroundCardColour();
    return _buildBackgroundCard(_buildRenderer(context, backgroundColour), backgroundColour);
  }

  Widget _buildRenderer(BuildContext context, Color backgroundColour) {
    switch (config.type) {
      case TileType.link:
        return LinkTileRenderer(config: config, backgroundColour: backgroundColour);
      case TileType.text:
        return TextTileRenderer(config: config);
      case TileType.image:
        return ImageTileRenderer(config: config);
      case TileType.sectionTitle:
        return SectionTitleRenderer(config: config);
      case TileType.map:
        return MapTileRenderer(config: config);
      case TileType.video:
        return VideoTileRenderer(config: config);
      case TileType.widgets:
        return InteractiveWidgetsTileRenderer(config: config);
      }
  }

  Color _getBackgroundCardColour() {
    if (config.type == TileType.link && config.colour == null) {
      final brandColour =
          locator<LinkRepository>().getLinkData(config.url ?? "").brandColour;
      return brandColour == "#000000" || brandColour == "#FFFFFF"
          ? Colors.white
          : locator<LinkRepository>()
                .getLinkData(config.url ?? "")
                .brandColour
                .toSuperLightColour();
    }  
      return config.colour != null ? config.colour!.toColour() : Colors.transparent;
  }

  Widget _buildBackgroundCard(Widget child, Color backgroundColour) {
    final hasTap = config.url != null;

    return BentoInteractionEffect(
      onTap: hasTap
          ? () {
              _trackTileTapped(config.title ?? '');
              launchUrl(
                Uri.parse(config.url!),
                mode: LaunchMode.externalApplication,
              );
            }
          : null,
      child: Card(
        elevation: config.type == TileType.sectionTitle ? 0 : 2,
        clipBehavior: Clip.antiAlias,
        color: backgroundColour,
        child: InkWell(
          onTap: null,
          child: Padding(
            padding: TileType.link == config.type
                ? TilePadding.tiny
                : EdgeInsets.zero,
            child: child,
          ),
        ),
      ),
    );
  }

  /// Slugifies [tileTitle] and fires the analytics event directly on
  /// [AnalyticsRepository], bypassing the now-deleted use case layer.
  void _trackTileTapped(String tileTitle) {
    final slug = tileTitle
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '_');
    locator<AnalyticsRepository>().trackTileTapped('tile_tapped_$slug');
  }
}
