import 'package:flutter/material.dart';

import '../../../../../domain/entities/tile_config.dart';
import '../../../../utils/app_styles.dart';

class SectionTitleRenderer extends StatelessWidget {
  final TileConfig config;

  const SectionTitleRenderer({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    // Section titles sit on the scaffold background so they follow the
    // active theme's surface text colour rather than a tile brand colour.
    final Color textColour = Theme.of(context).colorScheme.onSurface;

    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.only(left: AppInsets.m),
      child: config.title != null && config.title!.isNotEmpty
          ? Text(
              config.title!,
              style: ResponsiveText.titleSmall(context)?.copyWith(
          fontWeight: FontWeight.w600,
          color: textColour,
        ),
            )
          : const SizedBox.shrink(),
    );
  }
}
