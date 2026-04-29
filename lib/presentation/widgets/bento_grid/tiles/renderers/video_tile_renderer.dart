import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../../domain/entities/tile_config.dart';
import '../../../../utils/app_styles.dart';

/// Renders a [TileType.video] tile as a muted, looping inline video.
///
/// Video source resolution (in priority order):
///   1. [TileConfig.videoPath] starting with `assets/` → loaded as a Flutter asset
///   2. [TileConfig.videoPath] treated as a network URL
///   3. No source → shows a branded placeholder
///
/// The [TileConfig.url] field is intentionally ignored by this renderer —
/// tap-through navigation is handled upstream by [SmartBentoTile] as usual,
/// so a video tile can still be tappable if `url` is set in JSON.
///
/// Web note: muted autoplay is reliable across all modern browsers when
/// [VideoPlayerController] is initialised with `webOptions` set to autoPlay +
/// muted. We always mute because unmuted autoplay is blocked universally.
class VideoTileRenderer extends StatefulWidget {
  final TileConfig config;

  const VideoTileRenderer({super.key, required this.config});

  @override
  State<VideoTileRenderer> createState() => _VideoTileRendererState();
}

class _VideoTileRendererState extends State<VideoTileRenderer> {
  VideoPlayerController? _controller;
  bool _initialised = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _initialise();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initialise() async {
    final path = widget.config.videoPath;
    if (path == null || path.isEmpty) return;

    try {
      final controller = path.startsWith('assets/')
          ? VideoPlayerController.asset(path)
          : VideoPlayerController.networkUrl(
              Uri.parse(path),
              videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
            );

      await controller.initialize();
      controller.setLooping(true);
      controller.setVolume(0); // always muted — browser autoplay policy
      controller.play();

      if (mounted) {
        setState(() {
          _controller = controller;
          _initialised = true;
        });
      } else {
        controller.dispose();
      }
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error || (widget.config.videoPath == null)) {
      return _buildPlaceholder(context);
    }

    if (!_initialised) {
      return _buildLoading();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Fitted video — covers the tile without letterboxing
        FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: _controller!.value.size.width,
            height: _controller!.value.size.height,
            child: VideoPlayer(_controller!),
          ),
        ),

        // Subtle bottom scrim so title text is legible
        if (widget.config.title != null && widget.config.title!.isNotEmpty)
          _buildScrimWithTitle(context),
      ],
    );
  }

  Widget _buildScrimWithTitle(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppInsets.m,
          AppInsets.xl, // tall gradient fade
          AppInsets.m,
          AppInsets.m,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Color(0xCC000000)],
          ),
        ),
        child: Text(
          widget.config.title!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: ResponsiveText.labelMedium(context)?.copyWith(
            color: AppColors.textOnDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const ColoredBox(
      color: Color(0xFF111111),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white30,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF1A1A1A),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.videocam_off_outlined,
                size: AppIconSizes.xl, color: Colors.white24),
            const SizedBox(height: 8),
            Text(
              'No video source',
              style: ResponsiveText.caption(context)
                  ?.copyWith(color: Colors.white24),
            ),
          ],
        ),
      ),
    );
  }
}
