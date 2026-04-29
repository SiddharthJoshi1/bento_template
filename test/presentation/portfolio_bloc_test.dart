import 'package:flutter_test/flutter_test.dart';
import 'package:bento_template/domain/entities/portfolio_content.dart';
import 'package:bento_template/domain/entities/profile_data.dart';
import 'package:bento_template/domain/entities/tile_config.dart';
import 'package:bento_template/presentation/blocs/portfolio/portfolio_bloc.dart';
import 'package:bento_template/presentation/blocs/portfolio/portfolio_state.dart';
import 'package:bento_template/data/repos/remote_config_repo.dart';
import 'package:bento_template/core/network/remote_json_source.dart';
import 'package:bento_template/core/network/cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

// A fixed base URL used in tests so they are independent of the
// CONTENT_BASE_URL dart-define value (which is empty in CI without the flag).
const _testBaseUrl =
    'https://raw.githubusercontent.com/test-user/test-repo/content/';

PortfolioContent _makeContent(List<TileConfig> tiles) => PortfolioContent(
      tiles: tiles,
      profile: ProfileData.empty(),
    );

TileConfig _makeTile({String? imagePath}) => TileConfig(
      type: TileType.image,
      tileSize: TileSize.halfCard,
      title: 'T',
      imagePath: imagePath,
    );

/// Runs [convertTileAssetPathToNetworkPath] with an injected base URL
/// rather than relying on the compile-time dart-define.
void _convert(PortfolioBloc bloc, PortfolioContent content) {
  bloc.convertTileAssetPathToNetworkPath(content, baseUrl: _testBaseUrl);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PortfolioBloc bloc;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final cache = CacheManager(prefs);
    // RemoteJsonSource with no custom client — we never call load() in these tests
    final source = RemoteJsonSource();
    final repo = RemoteConfigRepository(remoteSource: source, cacheManager: cache);
    bloc = PortfolioBloc(repo);
  });

  tearDown(() => bloc.close());

  group('convertTileAssetPathToNetworkPath', () {
    test('prepends baseContentUrl to relative asset paths', () {
      final content = _makeContent([_makeTile(imagePath: 'assets/img.png')]);
      _convert(bloc, content);
      expect(
        content.tiles.first.imagePath,
        '${_testBaseUrl}assets/img.png',
      );
    });

    test('leaves absolute http URLs untouched', () {
      const url = 'https://images.unsplash.com/photo-123?w=800';
      final content = _makeContent([_makeTile(imagePath: url)]);
      _convert(bloc, content);
      expect(content.tiles.first.imagePath, url);
    });

    test('leaves absolute https URLs untouched', () {
      const url = 'https://raw.githubusercontent.com/user/repo/main/img.png';
      final content = _makeContent([_makeTile(imagePath: url)]);
      _convert(bloc, content);
      expect(content.tiles.first.imagePath, url);
    });

    test('skips tiles with null imagePath', () {
      final content = _makeContent([_makeTile(imagePath: null)]);
      _convert(bloc, content);
      expect(content.tiles.first.imagePath, isNull);
    });

    test('handles empty tile list', () {
      final content = _makeContent([]);
      expect(() => _convert(bloc, content), returnsNormally);
    });

    test('processes multiple tiles independently', () {
      final content = _makeContent([
        _makeTile(imagePath: 'assets/local.png'),
        _makeTile(imagePath: 'https://example.com/remote.png'),
        _makeTile(imagePath: null),
        _makeTile(imagePath: 'assets/another.png'),
      ]);

      _convert(bloc, content);

      expect(content.tiles[0].imagePath, '${_testBaseUrl}assets/local.png');
      expect(content.tiles[1].imagePath, 'https://example.com/remote.png');
      expect(content.tiles[2].imagePath, isNull);
      expect(content.tiles[3].imagePath, '${_testBaseUrl}assets/another.png');
    });

    test('does not double-prefix already-prefixed GitHub raw URLs', () {
      final alreadyPrefixed = '${_testBaseUrl}assets/img.png';
      final content = _makeContent([_makeTile(imagePath: alreadyPrefixed)]);
      _convert(bloc, content);
      expect(content.tiles.first.imagePath, alreadyPrefixed);
    });
  });

  group('PortfolioState', () {
    test('initial state is PortfolioLoading', () {
      expect(bloc.state, isA<PortfolioLoading>());
    });

    test('PortfolioLoaded holds content', () {
      final content = _makeContent([]);
      final state = PortfolioLoaded(content);
      expect(state.content, content);
    });

    test('PortfolioError holds message', () {
      const state = PortfolioError('something went wrong');
      expect(state.message, 'something went wrong');
    });
  });
}
