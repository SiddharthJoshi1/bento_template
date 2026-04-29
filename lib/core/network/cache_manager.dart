import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

/// Three-tier cache for `content.json`.
///
/// Read priority:
///   1. Memory   — in-process map, cleared on restart (instant)
///   2. Disk     — SharedPreferences, survives restarts
///   3. Bundled  — `assets/data/content.json`, always available
///
/// Write: saving remote JSON updates both memory and disk tiers.
class CacheManager {
  CacheManager(this._prefs);

  final SharedPreferences _prefs;

  // Tier 1 — in-memory, keyed by cache key.
  final Map<String, Map<String, dynamic>> _memory = {};

  // ---------------------------------------------------------------------------
  // Read
  // ---------------------------------------------------------------------------

  /// Returns the best available JSON for [key], working through the tiers.
  ///
  /// Never throws — falls through to the bundled asset as a last resort.
  Future<Map<String, dynamic>> get(String key) async {
    // Tier 1: memory
    if (_memory.containsKey(key)) return _memory[key]!;

    // Tier 2: disk
    final cached = _prefs.getString(key);
    if (cached != null) {
      try {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        _memory[key] = decoded;
        return decoded;
      } catch (_) {
        // Corrupted cache — fall through to bundled asset.
        await _prefs.remove(key);
      }
    }

    // Tier 3: bundled asset
    return _loadBundledAsset();
  }

  /// Returns the cached version string, or null if nothing is cached.
  String? getCachedVersion() => _prefs.getString(RemoteConstants.contentVersionKey);

  // ---------------------------------------------------------------------------
  // Write
  // ---------------------------------------------------------------------------

  /// Saves [json] to memory + disk under [key], and persists [version].
  Future<void> save(String key, Map<String, dynamic> json, String version) async {
    _memory[key] = json;
    await Future.wait([
      _prefs.setString(key, jsonEncode(json)),
      _prefs.setString(RemoteConstants.contentVersionKey, version),
    ]);
  }

  // ---------------------------------------------------------------------------
  // Private
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> _loadBundledAsset() async {
    final raw = await rootBundle.loadString('assets/data/content.json');
    return jsonDecode(raw) as Map<String, dynamic>;
  }
}
