import 'package:flutter_test/flutter_test.dart';
import 'package:bento_template/domain/entities/tile_config.dart';

void main() {
  group('TileConfig.fromJson', () {
    group('tile types', () {
      final sizes = {'tile_size': 'half_card'};

      test('parses section_title', () {
        final tile = TileConfig.fromJson({...sizes, 'type': 'section_title', 'title': 'Hello'});
        expect(tile.type, TileType.sectionTitle);
      });

      test('parses link', () {
        final tile = TileConfig.fromJson({...sizes, 'type': 'link', 'title': 'Link'});
        expect(tile.type, TileType.link);
      });

      test('parses text', () {
        final tile = TileConfig.fromJson({...sizes, 'type': 'text', 'title': 'Text'});
        expect(tile.type, TileType.text);
      });

      test('parses image', () {
        final tile = TileConfig.fromJson({...sizes, 'type': 'image', 'title': 'Image'});
        expect(tile.type, TileType.image);
      });

      test('parses map', () {
        final tile = TileConfig.fromJson({...sizes, 'type': 'map', 'title': 'Map', 'latitude': 51.5, 'longitude': -0.1});
        expect(tile.type, TileType.map);
      });

      test('parses video', () {
        final tile = TileConfig.fromJson({...sizes, 'type': 'video', 'title': 'Video'});
        expect(tile.type, TileType.video);
      });

      test('parses widgets', () {
        final tile = TileConfig.fromJson({...sizes, 'type': 'widgets', 'title': 'Widget', 'widget_id': 'spinner_v1'});
        expect(tile.type, TileType.widgets);
      });

      test('unknown type falls back to text', () {
        final tile = TileConfig.fromJson({...sizes, 'type': 'not_a_real_type', 'title': 'Fallback'});
        expect(tile.type, TileType.text);
      });
    });

    group('tile sizes', () {
      final base = {'type': 'text', 'title': 'T'};

      test('parses all current size keys', () {
        final cases = {
          'quarter_bar':   TileSize.quarterBar,
          'quarter_card':  TileSize.quarterCard,
          'quarter_tower': TileSize.quarterTower,
          'half_bar':      TileSize.halfBar,
          'half_card':     TileSize.halfCard,
          'half_tower':    TileSize.halfTower,
          'full_bar':      TileSize.fullBar,
          'full_card':     TileSize.fullCard,
          'full_tower':    TileSize.fullTower,
        };
        for (final entry in cases.entries) {
          final tile = TileConfig.fromJson({...base, 'tile_size': entry.key});
          expect(tile.tileSize, entry.value, reason: 'failed for ${entry.key}');
        }
      });

      test('parses legacy size keys', () {
        final legacy = {
          'small':            TileSize.quarterCard,
          'thin':             TileSize.halfBar,
          'medium':           TileSize.halfCard,
          'standard':         TileSize.fullCard,
          'banner':           TileSize.fullBar,
          'slim':             TileSize.quarterTower,
          'tall':             TileSize.halfTower,
          'fullsize':         TileSize.fullTower,
          'long_horizontal':  TileSize.fullBar,
          'long_vertical':    TileSize.quarterTower,
        };
        for (final entry in legacy.entries) {
          final tile = TileConfig.fromJson({...base, 'tile_size': entry.key});
          expect(tile.tileSize, entry.value, reason: 'failed for legacy key ${entry.key}');
        }
      });

      test('unknown size falls back to halfCard', () {
        final tile = TileConfig.fromJson({...base, 'tile_size': 'not_a_size'});
        expect(tile.tileSize, TileSize.halfCard);
      });
    });

    group('optional fields', () {
      test('parses all optional fields when present', () {
        final tile = TileConfig.fromJson({
          'type': 'link',
          'tile_size': 'half_card',
          'title': 'My Link',
          'url': 'https://example.com',
          'image_path': 'assets/img.png',
          'colour': '#ff0000',
          'latitude': 51.5074,
          'longitude': -0.1278,
          'widget_id': 'spinner_v1',
          'widget_config': {'items': ['a', 'b']},
          'video_path': 'assets/video.mp4',
        });

        expect(tile.title, 'My Link');
        expect(tile.url, 'https://example.com');
        expect(tile.imagePath, 'assets/img.png');
        expect(tile.colour, '#ff0000');
        expect(tile.latitude, 51.5074);
        expect(tile.longitude, -0.1278);
        expect(tile.widgetId, 'spinner_v1');
        expect(tile.widgetConfig, {'items': ['a', 'b']});
        expect(tile.videoPath, 'assets/video.mp4');
      });

      test('optional fields are null when absent', () {
        final tile = TileConfig.fromJson({'type': 'text', 'tile_size': 'half_card', 'title': 'T'});
        expect(tile.url, isNull);
        expect(tile.imagePath, isNull);
        expect(tile.colour, isNull);
        expect(tile.latitude, isNull);
        expect(tile.longitude, isNull);
        expect(tile.widgetId, isNull);
        expect(tile.widgetConfig, isNull);
        expect(tile.videoPath, isNull);
      });

      test('latitude and longitude parse from int JSON values', () {
        final tile = TileConfig.fromJson({
          'type': 'map',
          'tile_size': 'half_card',
          'title': 'Map',
          'latitude': 51,
          'longitude': 0,
        });
        expect(tile.latitude, 51.0);
        expect(tile.longitude, 0.0);
      });
    });
  });

  group('TileConfig computed properties', () {
    TileConfig makeTile(TileSize size) => TileConfig(
          type: TileType.text,
          tileSize: size,
          title: 'T',
        );

    group('isBar', () {
      test('true for fullBar', () => expect(makeTile(TileSize.fullBar).isBar, isTrue));
      test('true for halfBar', () => expect(makeTile(TileSize.halfBar).isBar, isTrue));
      test('true for quarterBar', () => expect(makeTile(TileSize.quarterBar).isBar, isTrue));
      test('false for halfCard', () => expect(makeTile(TileSize.halfCard).isBar, isFalse));
      test('false for halfTower', () => expect(makeTile(TileSize.halfTower).isBar, isFalse));
    });

    group('isTower', () {
      test('true for fullTower', () => expect(makeTile(TileSize.fullTower).isTower, isTrue));
      test('true for halfTower', () => expect(makeTile(TileSize.halfTower).isTower, isTrue));
      test('true for quarterTower', () => expect(makeTile(TileSize.quarterTower).isTower, isTrue));
      test('false for halfCard', () => expect(makeTile(TileSize.halfCard).isTower, isFalse));
      test('false for halfBar', () => expect(makeTile(TileSize.halfBar).isTower, isFalse));
    });
  });

  group('TileConfig.copyWith', () {
    final original = TileConfig(
      type: TileType.link,
      tileSize: TileSize.halfCard,
      title: 'Original',
      url: 'https://example.com',
      imagePath: 'assets/img.png',
      colour: '#000000',
    );

    test('returns new instance with updated fields', () {
      final updated = original.copyWith(title: 'Updated', tileSize: TileSize.fullTower);
      expect(updated.title, 'Updated');
      expect(updated.tileSize, TileSize.fullTower);
    });

    test('preserves unchanged fields', () {
      final updated = original.copyWith(title: 'Updated');
      expect(updated.url, 'https://example.com');
      expect(updated.imagePath, 'assets/img.png');
      expect(updated.colour, '#000000');
      expect(updated.type, TileType.link);
    });

    test('does not mutate original', () {
      original.copyWith(title: 'Updated');
      expect(original.title, 'Original');
    });
  });
}
