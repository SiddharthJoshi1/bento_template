import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';

/// Typed exception thrown when the remote fetch fails for any reason.
class RemoteFetchException implements Exception {
  const RemoteFetchException(this.message);
  final String message;

  @override
  String toString() => 'RemoteFetchException: $message';
}

/// Fetches `content.json` from the configured remote URL.
///
/// Returns the decoded JSON map on success. Throws [RemoteFetchException] on
/// any network error, non-200 status, timeout, or malformed JSON.
class RemoteJsonSource {
  RemoteJsonSource({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Map<String, dynamic>> fetchContentJson() async {
    try {
      final response = await _client
          .get(Uri.parse(RemoteConstants.contentJsonUrlPath))
          .timeout(
            RemoteConstants.fetchTimeout,
          );

      if (response.statusCode != 200) {
        throw RemoteFetchException(
          'Unexpected status ${response.statusCode}',
        );
      }

      return jsonDecode(response.body) as Map<String, dynamic>;
    } on TimeoutException {
      throw const RemoteFetchException('Request timed out');
    } on RemoteFetchException {
      rethrow;
    } catch (e) {
      throw RemoteFetchException('Network error: $e');
    }
  }
}
