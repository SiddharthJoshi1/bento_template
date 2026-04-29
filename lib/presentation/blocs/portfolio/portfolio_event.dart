/// Events for [PortfolioBloc].
abstract class PortfolioEvent {
  const PortfolioEvent();
}

/// Fired once on app startup to trigger remote fetch + OG enrichment.
class LoadPortfolio extends PortfolioEvent {
  const LoadPortfolio();
}
