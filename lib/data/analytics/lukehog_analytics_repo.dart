import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:lukehog_client/lukehog_client.dart';

import '../../domain/repos/analytics_repo.dart';

/// Lukehog implementation of [AnalyticsRepository].
///
/// All capture calls are gated on [kReleaseMode] so analytics never fires
/// during development or testing. Swap this class for a different impl by
/// registering a new concrete type in [setupLocator] — no call sites change.
class LukehogAnalyticsRepository implements AnalyticsRepository {
  final LukehogClient _client;

  const LukehogAnalyticsRepository(this._client);

  Future<void> _trackEvent(
    String eventName, {
    Map<String, dynamic>? parameters,
  }) async {
    if (!kReleaseMode) return;
    await _client.capture(
      eventName,
      properties: parameters ?? {},
      timestamp: DateTime.now(),
    );
  }

  @override
  void trackPortfolioOpened() {
    _trackEvent('portfolio_opened');
  }

  @override
  void trackTileTapped(String eventName) {
    _trackEvent(eventName);
  }

  @override
  void trackError(String context) {
    _trackEvent('error_occurred', parameters: {'context': context});
  }
}
