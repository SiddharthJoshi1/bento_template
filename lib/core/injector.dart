import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:lukehog_client/lukehog_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/analytics/lukehog_analytics_repo.dart';
import '../data/repos/remote_config_repo.dart';
import '../presentation/blocs/portfolio/portfolio_bloc.dart';
import '../domain/entities/link.dart';
import '../domain/repos/analytics_repo.dart';
import '../domain/repos/link_repo.dart';
import 'constants.dart';
import 'network/cache_manager.dart';
import 'network/remote_json_source.dart';

final locator = GetIt.instance;

/// Loads and registers all dependencies. Must be awaited before [runApp].
///
/// Reads one asset file at startup:
///   - `assets/data/popular_links.json` → [LinkRepository]
///
/// Portfolio content (tiles + profile) is fetched remotely by [PortfolioBloc]
/// via [RemoteConfigRepository] — not loaded from bundle here.
Future<void> setupLocator() async {
  // --- SharedPreferences (needed by CacheManager) ---
  final prefs = await SharedPreferences.getInstance();

  // --- popular_links.json → LinkRepository ---
  final linksRaw = await rootBundle.loadString('assets/data/popular_links.json');
  final Map<String, dynamic> linksJson = jsonDecode(linksRaw) as Map<String, dynamic>;
  final Map<String, LinkConfig> platforms = linksJson.map(
    (key, value) => MapEntry(
      key,
      LinkConfig.fromJson(value as Map<String, dynamic>),
    ),
  );

  locator.registerLazySingleton<LinkRepository>(
    () => LinkRepositoryImpl(platforms),
  );

  // --- Network layer ---
  locator.registerLazySingleton<CacheManager>(() => CacheManager(prefs));
  locator.registerLazySingleton<RemoteJsonSource>(() => RemoteJsonSource());

  locator.registerLazySingleton<RemoteConfigRepository>(
    () => RemoteConfigRepository(
      remoteSource: locator<RemoteJsonSource>(),
      cacheManager: locator<CacheManager>(),
    ),
  );

  // --- PortfolioBloc (factory — new instance per BlocProvider call) ---
  locator.registerFactory<PortfolioBloc>(
    () => PortfolioBloc(locator<RemoteConfigRepository>()),
  );

  // --- Analytics ---
  locator.registerLazySingleton<AnalyticsRepository>(
    () => LukehogAnalyticsRepository(
      LukehogClient(AnalyticsConstants.lukehogAppId),
    ),
  );
}
