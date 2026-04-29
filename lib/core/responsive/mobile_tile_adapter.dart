import 'package:flutter/material.dart';

import '../../../../../../core/constants.dart';
import '../../../../../../domain/entities/tile_config.dart';

/// Adapts tile configs and computes heights for the mobile list layout.
///
/// On mobile, tiles are rendered in a plain [ListView] so each tile needs
/// an explicit pixel height. Heights use the same [LayoutConstants.unitHeight]
/// as the desktop grid so proportions stay consistent across platforms.
///
/// Full-width tiles are collapsed to half-width equivalents on mobile.
/// Quarter-width tiles are collapsed to half-width equivalents on mobile.
class MobileTileAdapter {
  /// Returns a copy of [original] with its [TileSize] mapped to a
  /// mobile-friendly equivalent. Section title tiles are returned unchanged.
  static TileConfig getMobileConfig(TileConfig original) {
    if (original.type == TileType.sectionTitle) return original;

    switch (original.tileSize) {
      // Quarter-wide tiles → expand to half-wide on mobile
      case TileSize.quarterBar:
        return original.copyWith(tileSize: TileSize.fullBar);
      case TileSize.quarterCard:
        return original.copyWith(tileSize: TileSize.fullBar);
      case TileSize.quarterTower:
        return original.copyWith(tileSize: TileSize.halfCard);
      // Half-wide tiles → unchanged
      case TileSize.halfBar:
        return original.copyWith(tileSize: TileSize.fullBar);
      case TileSize.halfCard:
       return original.copyWith(tileSize: TileSize.fullCard);
      case TileSize.halfTower:
        return original.copyWith(tileSize: TileSize.fullCard);
      // Full-wide tiles → collapse to half-wide on mobile
      case TileSize.fullBar:
        return original;
      case TileSize.fullCard:
        return original;
      case TileSize.fullTower:
        return original;
    }
  }

}
