import '../../core/network/cache_manager.dart';
import '../../core/network/remote_json_source.dart';
import '../../core/constants.dart';
import '../../domain/entities/portfolio_content.dart';
import '../../domain/entities/profile_data.dart';
import '../../domain/entities/tile_config.dart';

/// Orchestrates remote fetching and caching of portfolio content.
///
/// Call [load] once on startup. It:
///   1. Reads best available content from [CacheManager] (instant)
///   2. Attempts a remote fetch from the configured URL
///   3. If the remote version is newer, updates cache + swaps content
///   4. Parses and returns [PortfolioContent]
///
/// All failures are handled gracefully — the bundled asset is the final
/// fallback so the app always has content to display.
class RemoteConfigRepository {
  RemoteConfigRepository({
    required RemoteJsonSource remoteSource,
    required CacheManager cacheManager,
  }) : _remote = remoteSource,
       _cache = cacheManager;

  final RemoteJsonSource _remote;
  final CacheManager _cache;

  /// Loads portfolio content and returns the result.
  Future<PortfolioContent> load() async {
    // --- Step 1: get best locally-available content immediately ---
    var contentJson = await _cache.get(RemoteConstants.contentCacheKey);

    // --- Step 2: attempt remote fetch ---
    try {
      final remoteJson = await _remote.fetchContentJson();
      final remoteVersion = remoteJson['version'] as String? ?? '0.0.0';
      final cachedVersion = _cache.getCachedVersion() ?? '0.0.0';

      if (_isNewer(remoteVersion, cachedVersion)) {
        await _cache.save(
          RemoteConstants.contentCacheKey,
          remoteJson,
          remoteVersion,
        );
        contentJson = remoteJson;
      }
    } catch (err) {
      // Remote fetch failed — continue with cached/bundled content.
    }

    // --- Step 3: parse and return ---
    final profile = ProfileData.fromJson(
      contentJson['profile'] as Map<String, dynamic>,
    );

    List<TileConfig> tiles = (contentJson['tiles'] as List<dynamic>)
        .map((e) => TileConfig.fromJson(e as Map<String, dynamic>))
        .toList();

    return PortfolioContent(tiles: tiles, profile: profile);
  }

  // ---------------------------------------------------------------------------
  // Private
  // ---------------------------------------------------------------------------

  /// Compares semver strings. Returns true if [remote] is newer than [cached].
  bool _isNewer(String remote, String cached) {
    try {
      final r = _parseSemver(remote);
      final c = _parseSemver(cached);
      for (var i = 0; i < 3; i++) {
        if (r[i] > c[i]) return true;
        if (r[i] < c[i]) return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  List<int> _parseSemver(String v) =>
      v.split('.').map((p) => int.tryParse(p) ?? 0).toList();
}
