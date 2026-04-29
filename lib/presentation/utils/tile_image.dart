import 'package:flutter/material.dart';

/// Renders an image from either a local asset path or a remote URL,
/// chosen automatically based on whether [path] starts with `http`.
///
/// Used by tile renderers so OG-enriched remote URLs and bundled asset
/// paths are handled transparently without branching at each call site.
class TileImage extends StatelessWidget {
  const TileImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width = double.infinity,
    this.height = double.infinity,
  });

  final String path;
  final BoxFit fit;
  final double width;
  final double height;

  bool get _isRemote => path.startsWith('http');

  @override
  Widget build(BuildContext context) {
    if (_isRemote) {
      return Image.network(
        path,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, _, _) => const SizedBox.shrink(),
      );
    }

    return Image.asset(
      path,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, _, _) => const SizedBox.shrink(),
    );
  }
}
