import 'package:flutter/material.dart';

import '../../../../../domain/entities/tile_config.dart';
import '../../../../utils/app_styles.dart';
import '../../../../utils/tile_image.dart';

class ImageTileRenderer extends StatelessWidget {
  final TileConfig config;

  const ImageTileRenderer({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    if (config.imagePath == null) return const SizedBox.shrink();

    final image = TileImage(path: config.imagePath!);

    // No title — pure image, no overlay
    if (config.title == null || config.title!.isEmpty) return image;

    // Title present — subtle gradient scrim for legibility
    return Stack(
      fit: StackFit.expand,
      children: [
        image,
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.35),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: AppInsets.m,
          left: AppInsets.m,
          right: AppInsets.m,
          child: Text(
            config.title!,
            style: ResponsiveText.titleSmall(context)?.copyWith(
              color: AppColors.textOnDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
