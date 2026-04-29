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

    return Center(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
      
          // Profile header — mobile only, desktop uses the side panel
          if (isMobile) ...[
             SliverToBoxAdapter(child: ProfileSection(profile: profileData)),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
      
          // Bento grid via the package delegate
          SliverPadding(
            padding: isMobile
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: BentoGridDelegate(
                items: items,
                unitHeight: LayoutConstants.unitHeight,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => items[index].child,
                childCount: items.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
