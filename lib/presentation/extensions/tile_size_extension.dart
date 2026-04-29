import 'package:bento_layout/bento_layout.dart';
import '../../domain/entities/tile_config.dart';

/// Maps [TileSize] (bento_template's domain enum) to [BentoItemSize]
/// (the package's layout enum).
///
/// This is the only file that knows about both enums — keeping the
/// mapping isolated so neither the package nor the domain entity
/// needs to reference the other.
extension TileSizeToBentoItemSize on TileSize {
  BentoItemSize toBentoItemSize() {
    switch (this) {
      case TileSize.quarterBar:
        return BentoItemSize.quarterBar;
      case TileSize.quarterCard:
        return BentoItemSize.quarterCard;
      case TileSize.quarterTower:
        return BentoItemSize.quarterTower;
      case TileSize.halfBar:
        return BentoItemSize.halfBar;
      case TileSize.halfCard:
        return BentoItemSize.halfCard;
      case TileSize.halfTower:
        return BentoItemSize.halfTower;
      case TileSize.fullBar:
        return BentoItemSize.fullBar;
      case TileSize.fullCard:
        return BentoItemSize.fullCard;
      case TileSize.fullTower:
        return BentoItemSize.fullTower;
    }
  }
}
