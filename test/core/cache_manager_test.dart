import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bento_template/core/network/cache_manager.dart';
import 'package:bento_template/core/constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<CacheManager> makeManager() async {
    final prefs = await SharedPreferences.getInstance();
    return CacheManager(prefs);
  }

  group('CacheManager.get', () {
    test('falls back to bundled asset when nothing is cached', () async {
      final manager = await makeManager();
      // The bundled asset at assets/data/content.json must be registered
      // in pubspec.yaml — this test verifies the fallback path resolves.
      final result = await manager.get(RemoteConstants.contentCacheKey);
      expect(result, isA<Map<String, dynamic>>());
      expect(result.containsKey('tiles'), isTrue);
    });

    test('returns disk cache when available', () async {
      final prefs = await SharedPreferences.getInstance();
      final payload = '{"version":"1.0.0","tiles":[],"profile":{"name":"A","bio":"B","avatar_path":"x"}}';
      await prefs.setString(RemoteConstants.contentCacheKey, payload);

      final manager = CacheManager(prefs);
      final result = await manager.get(RemoteConstants.contentCacheKey);
      expect(result['version'], '1.0.0');
    });

    test('returns memory cache on second call without hitting disk', () async {
      final manager = await makeManager();

      // Prime memory by saving
      final data = {'version': '2.0.0', 'tiles': [], 'profile': {'name': 'A', 'bio': 'B', 'avatar_path': 'x'}};
      await manager.save(RemoteConstants.contentCacheKey, data, '2.0.0');

      // Corrupt disk to prove memory tier is used
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(RemoteConstants.contentCacheKey, 'not_valid_json{{{');

      final result = await manager.get(RemoteConstants.contentCacheKey);
      expect(result['version'], '2.0.0');
    });

    test('recovers gracefully from corrupted disk cache', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(RemoteConstants.contentCacheKey, 'corrupted{{{json');

      final manager = CacheManager(prefs);
      // Should fall through to bundled asset — no exception thrown
      final result = await manager.get(RemoteConstants.contentCacheKey);
      expect(result, isA<Map<String, dynamic>>());
    });
  });

  group('CacheManager.save', () {
    test('saves version to SharedPreferences', () async {
      final manager = await makeManager();
      final data = {'version': '1.2.3', 'tiles': [], 'profile': {'name': 'A', 'bio': 'B', 'avatar_path': 'x'}};
      await manager.save(RemoteConstants.contentCacheKey, data, '1.2.3');

      expect(manager.getCachedVersion(), '1.2.3');
    });

    test('saved data is returned by subsequent get', () async {
      final manager = await makeManager();
      final data = {'version': '3.0.0', 'tiles': [], 'profile': {'name': 'A', 'bio': 'B', 'avatar_path': 'x'}};
      await manager.save(RemoteConstants.contentCacheKey, data, '3.0.0');

      final result = await manager.get(RemoteConstants.contentCacheKey);
      expect(result['version'], '3.0.0');
    });

    test('overwrites previous cached data', () async {
      final manager = await makeManager();
      final v1 = {'version': '1.0.0', 'tiles': [], 'profile': {'name': 'A', 'bio': 'B', 'avatar_path': 'x'}};
      final v2 = {'version': '2.0.0', 'tiles': [], 'profile': {'name': 'A', 'bio': 'B', 'avatar_path': 'x'}};

      await manager.save(RemoteConstants.contentCacheKey, v1, '1.0.0');
      await manager.save(RemoteConstants.contentCacheKey, v2, '2.0.0');

      final result = await manager.get(RemoteConstants.contentCacheKey);
      expect(result['version'], '2.0.0');
      expect(manager.getCachedVersion(), '2.0.0');
    });
  });

  group('CacheManager.getCachedVersion', () {
    test('returns null when nothing has been saved', () async {
      final manager = await makeManager();
      expect(manager.getCachedVersion(), isNull);
    });

    test('returns version string after save', () async {
      final manager = await makeManager();
      final data = {'version': '4.2.1', 'tiles': [], 'profile': {'name': 'A', 'bio': 'B', 'avatar_path': 'x'}};
      await manager.save(RemoteConstants.contentCacheKey, data, '4.2.1');
      expect(manager.getCachedVersion(), '4.2.1');
    });
  });
}
