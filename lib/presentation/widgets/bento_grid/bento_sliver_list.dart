import 'package:bento_template/domain/entities/profile_data.dart';
import 'package:bento_layout/bento_layout.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants.dart';
import '../../../../domain/entities/tile_config.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/responsive/mobile_tile_adapter.dart';
import '../../extensions/tile_size_extension.dart';
import '../profile/profile_section.dart';
import 'tiles/smart_bento_tile.dart';

class BentoSliverList extends StatelessWidget {
  final List<TileConfig> tiles;
  final ProfileData profileData;

  const BentoSliverList({super.key, required this.tiles, required this.profileData});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Breakpoints.isMobile(context);

    final List<TileConfig> resolvedTiles = isMobile
        ? tiles.map((t) => MobileTileAdapter.getMobileConfig(t)).toList()
        : tiles;

    final List<BentoItem> items = resolvedTiles
        .map(
          (t) => BentoItem(
            size: t.tileSize.toBentoItemSize(),
            child: Padding(
              padding: isMobile
                  ? const EdgeInsets.all(5)
                  : const EdgeInsets.all(10),
              child: SmartBentoTile(config: t),
            ),
          ),
        )
        .toList();

    final horizontalPadding = isMobile ? 0.0 : 20.0;

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth - (horizontalPadding * 2);

          final details = SkylinePacking.pack(
            items: items,
            totalWidth: availableWidth,
            unitHeight: LayoutConstants.unitHeight,
          );

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  if (isMobile) ...[
                    ProfileSection(profile: profileData),
                    const SizedBox(height: 20),
                  ],

                  SizedBox(
                    height: details.totalHeight,
                    width: availableWidth,
                    child: Stack(
                      children: [
                        for (final entry in details.geometryMap.entries)
                          Positioned(
                            left: entry.value.crossAxisOffset,
                            top: entry.value.scrollOffset,
                            width: entry.value.crossAxisExtent,
                            height: entry.value.mainAxisExtent,
                            child: items[entry.key].child,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
