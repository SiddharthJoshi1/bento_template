import '../../../domain/entities/portfolio_content.dart';

/// States for [PortfolioBloc].
abstract class PortfolioState {
  const PortfolioState();
}

/// Initial state — shown while remote fetch + OG enrichment is in progress.
class PortfolioLoading extends PortfolioState {
  const PortfolioLoading();
}

/// Content is ready. [content] is fully enriched with OG images.
class PortfolioLoaded extends PortfolioState {
  const PortfolioLoaded(this.content);
  final PortfolioContent content;
}

/// Something went wrong at every fallback tier.
/// In practice this should never happen — the bundled asset is always
/// available — but it's here for completeness.
class PortfolioError extends PortfolioState {
  const PortfolioError(this.message);
  final String message;
}
