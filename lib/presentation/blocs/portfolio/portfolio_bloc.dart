import 'package:bento_template/domain/entities/portfolio_content.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../../../data/repos/remote_config_repo.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';

/// Drives the portfolio loading lifecycle.
///
/// On [LoadPortfolio]:
///   1. Emits [PortfolioLoading]
///   2. Calls [RemoteConfigRepository.load] — handles remote fetch, caching,
///      version comparison, and OG image enrichment
///   3. Emits [PortfolioLoaded] on success or [PortfolioError] on failure
///
/// Usage:
/// ```dart
/// context.read<PortfolioBloc>().add(const LoadPortfolio());
/// ```
class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  PortfolioBloc(this._repo) : super(const PortfolioLoading()) {
    on<LoadPortfolio>(_onLoad);
  }

  final RemoteConfigRepository _repo;

  Future<void> _onLoad(
    LoadPortfolio event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(const PortfolioLoading());
    try {
      final content = await _repo.load();
      convertTileAssetPathToNetworkPath(content);
      emit(PortfolioLoaded(content));
    } catch (e) {
      emit(PortfolioError(e.toString()));
    }
  }

  /// Converts relative asset image paths to absolute GitHub raw content URLs.
  ///
  /// Paths that are already absolute (start with 'http') are left untouched —
  /// this covers external URLs such as Unsplash images or any other remote source.
  ///
  /// [baseUrl] is optional and defaults to [RemoteConstants.baseContentUrl].
  /// Pass an explicit value in tests to avoid depending on the dart-define.
  void convertTileAssetPathToNetworkPath(
    PortfolioContent content, {
    String? baseUrl,
  }) {
    final base = baseUrl ?? RemoteConstants.baseContentUrl;
    for (int i = 0; i < content.tiles.length; i++) {
      final tile = content.tiles[i];
      final path = tile.imagePath;
      if (path != null && !path.startsWith('http')) {
        content.tiles[i] = tile.copyWith(
          imagePath: base + path,
        );
      }
    }
  }
}
