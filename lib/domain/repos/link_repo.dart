import '../entities/link.dart';

abstract class LinkRepository {
  LinkConfig getLinkData(String url);
}

class LinkRepositoryImpl implements LinkRepository {
  LinkRepositoryImpl(this._platforms);

  /// Pre-parsed platform map loaded from `assets/data/popular_links.json`
  /// at startup. Keys are platform identifiers e.g. `'instagram'`, `'github'`.
  final Map<String, LinkConfig> _platforms;

  @override
  LinkConfig getLinkData(String url) {
    if (url.isEmpty) return LinkConfig.fallback;

    // Normalise — add scheme if missing so Uri.parse works reliably.
    Uri? uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      uri = Uri.tryParse('https://$url');
    }

    final String host = uri?.host.toLowerCase() ?? '';

    // 1. Special short / alternative domains that don't match by key name.
    if (host.contains('youtu.be')) return _platforms['youtube'] ?? LinkConfig.fallback;
    if (host.contains('t.me')) return _platforms['telegram'] ?? LinkConfig.fallback;
    if (host.contains('music.apple.com')) return _platforms['apple_music'] ?? LinkConfig.fallback;

    // 2. Scan all keys — return the first whose key appears in the host.
    for (final key in _platforms.keys) {
      if (key == 'default') continue;
      if (host.contains(key)) return _platforms[key]!;
    }

    // 3. Fall back to the default entry from JSON, or the const fallback.
    return _platforms['default'] ?? LinkConfig.fallback;
  }
}
