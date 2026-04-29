import 'dart:ui';

import 'package:bento_template/presentation/blocs/theme/theme_cubit.dart';
import 'package:bento_template/presentation/pages/home_page.dart';
import 'package:bento_template/core/theme/app_theme.dart';
import 'package:bento_template/presentation/widgets/profile/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/injector.dart';
import 'domain/repos/analytics_repo.dart';
import 'presentation/blocs/portfolio/portfolio_bloc.dart';
import 'presentation/blocs/portfolio/portfolio_event.dart';
import 'presentation/blocs/portfolio/portfolio_state.dart';
import 'presentation/widgets/bento_grid/bento_sliver_list.dart';
import 'presentation/widgets/bento_states/bento_error_screen.dart';
import 'presentation/widgets/bento_states/bento_loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  // --- Analytics: cold start ---
  locator<AnalyticsRepository>().trackPortfolioOpened();

  // --- Analytics: error hooks ---
  final analytics = locator<AnalyticsRepository>();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    analytics.trackError('flutter_error');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    analytics.trackError('platform_error');
    return false;
  };

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (_) => locator<PortfolioBloc>()..add(const LoadPortfolio()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Bento Portfolio',
            theme: AppTheme.light(themeState.flavour.light),
            darkTheme: AppTheme.dark(themeState.flavour.dark),
            themeMode: themeState.mode,
            home: const _PortfolioShell(),
          );
        },
      ),
    );
  }
}

/// Listens to [PortfolioBloc] and routes between loading, loaded, and error.
class _PortfolioShell extends StatelessWidget {
  const _PortfolioShell();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, state) {
        return switch (state) {
          PortfolioLoading() => const BentoLoadingScreen(),
          PortfolioLoaded(:final content) => HomePage(
              profileWidget: ProfileSection(profile: content.profile),
              tileSectionWidget: BentoSliverList(tiles: content.tiles, profileData: content.profile),
            ),
          PortfolioError(:final message) => BentoErrorScreen(message: message),
          _ => const BentoLoadingScreen(),
        };
      },
    );
  }
}
