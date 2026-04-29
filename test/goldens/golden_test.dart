import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:bento_template/presentation/widgets/bento_states/bento_loading_screen.dart';
import 'package:bento_template/presentation/widgets/bento_states/bento_error_screen.dart';
import 'package:bento_template/presentation/widgets/bento_grid/tiles/renderers/section_title_renderer.dart';
import 'package:bento_template/presentation/widgets/bento_grid/tiles/renderers/text_tile_renderer.dart';
import 'package:bento_template/presentation/widgets/bento_grid/tiles/renderers/image_tile_renderer.dart';
import 'package:bento_template/presentation/widgets/bento_grid/tiles/renderers/link_tile_renderer.dart';
import 'package:bento_template/domain/entities/tile_config.dart';
import 'package:bento_template/domain/entities/link.dart';
import 'package:bento_template/domain/repos/link_repo.dart';
import 'package:bento_template/domain/repos/analytics_repo.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Stub link repo — returns a predictable fallback for any URL, no asset load.
class _StubLinkRepo implements LinkRepository {
  @override
  LinkConfig getLinkData(String url) => const LinkConfig(
    linkTitle: 'GitHub',
    linkIcon: 'fa-brands fa-github',
    brandColour: '#24292e',
  );
}

/// Stub analytics — no-op.
class _StubAnalyticsRepo implements AnalyticsRepository {
  @override
  void trackTileTapped(String event) {}

  @override
  void trackPortfolioOpened() {}

  @override
  void trackError(String context) {}
}

/// Wraps [child] in a fixed-size Material app with a light theme.
Widget _light(Widget child, {Size size = const Size(300, 200)}) =>
    _themed(child, ThemeData.light(useMaterial3: true), size);

/// Wraps [child] in a fixed-size Material app with a dark theme.
Widget _dark(Widget child, {Size size = const Size(300, 200)}) =>
    _themed(child, ThemeData.dark(useMaterial3: true), size);

Widget _themed(Widget child, ThemeData theme, Size size) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: theme,
  home: MediaQuery(
    data: MediaQueryData(size: size),
    child: Scaffold(
      body: SizedBox(width: size.width, height: size.height, child: child),
    ),
  ),
);

void _setViewSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
}

// ---------------------------------------------------------------------------
// Setup / teardown
// ---------------------------------------------------------------------------

void _setupLocator() {
  final locator = GetIt.instance;
  if (!locator.isRegistered<LinkRepository>()) {
    locator.registerSingleton<LinkRepository>(_StubLinkRepo());
  }
  if (!locator.isRegistered<AnalyticsRepository>()) {
    locator.registerSingleton<AnalyticsRepository>(_StubAnalyticsRepo());
  }
}

// ---------------------------------------------------------------------------
// Golden tests
// ---------------------------------------------------------------------------

void main() {
  // Run flutter test --update-goldens test/goldens/golden_test.dart to
  // generate the PNG reference files. Commit them to source control.
  // After that, flutter test compares pixel-by-pixel without the flag.

  setUpAll(_setupLocator);

  tearDownAll(() async => GetIt.instance.reset());

  group('State screens', () {
    testWidgets('BentoLoadingScreen — light', (tester) async {
      _setViewSize(tester, const Size(400, 400));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _light(const BentoLoadingScreen(), size: const Size(400, 400)),
      );
      await tester.pump(Duration.zero);

      await expectLater(
        find.byType(BentoLoadingScreen),
        matchesGoldenFile('goldens/bento_loading_screen_light.png'),
      );
    });

    testWidgets('BentoLoadingScreen — dark', (tester) async {
      _setViewSize(tester, const Size(400, 400));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _dark(const BentoLoadingScreen(), size: const Size(400, 400)),
      );
      await tester.pump(Duration.zero);

      await expectLater(
        find.byType(BentoLoadingScreen),
        matchesGoldenFile('goldens/bento_loading_screen_dark.png'),
      );
    });

    testWidgets('BentoErrorScreen — light', (tester) async {
      _setViewSize(tester, const Size(400, 400));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _light(
          const BentoErrorScreen(message: 'Something went wrong'),
          size: const Size(400, 400),
        ),
      );
      await tester.pump();

      await expectLater(
        find.byType(BentoErrorScreen),
        matchesGoldenFile('goldens/bento_error_screen_light.png'),
      );
    });

    testWidgets('BentoErrorScreen — dark', (tester) async {
      _setViewSize(tester, const Size(400, 400));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _dark(
          const BentoErrorScreen(message: 'Something went wrong'),
          size: const Size(400, 400),
        ),
      );
      await tester.pump();

      await expectLater(
        find.byType(BentoErrorScreen),
        matchesGoldenFile('goldens/bento_error_screen_dark.png'),
      );
    });
  });

  group('SectionTitleRenderer', () {
    final config = TileConfig(
      type: TileType.sectionTitle,
      tileSize: TileSize.fullBar,
      title: "What I'm working on.",
    );

    testWidgets('light', (tester) async {
      _setViewSize(tester, const Size(600, 60));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _light(SectionTitleRenderer(config: config), size: const Size(600, 60)),
      );

      await expectLater(
        find.byType(SectionTitleRenderer),
        matchesGoldenFile('goldens/section_title_light.png'),
      );
    });

    testWidgets('dark', (tester) async {
      _setViewSize(tester, const Size(600, 60));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _dark(SectionTitleRenderer(config: config), size: const Size(600, 60)),
      );

      await expectLater(
        find.byType(SectionTitleRenderer),
        matchesGoldenFile('goldens/section_title_dark.png'),
      );
    });
  });

  group('TextTileRenderer', () {
    testWidgets('card layout — amber — light', (tester) async {
      _setViewSize(tester, const Size(300, 200));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final config = TileConfig(
        type: TileType.text,
        tileSize: TileSize.halfCard,
        title: 'I build things that feel good to use.',
        colour: '#f9aa3a',
      );

      await tester.pumpWidget(_light(TextTileRenderer(config: config)));

      await expectLater(
        find.byType(TextTileRenderer),
        matchesGoldenFile('goldens/text_tile_card_amber_light.png'),
      );
    });

    testWidgets('card layout — dark colour — dark theme', (tester) async {
      _setViewSize(tester, const Size(300, 200));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final config = TileConfig(
        type: TileType.text,
        tileSize: TileSize.halfCard,
        title: 'I build things that feel good to use.',
        colour: '#1a1a2e',
      );

      await tester.pumpWidget(_dark(TextTileRenderer(config: config)));

      await expectLater(
        find.byType(TextTileRenderer),
        matchesGoldenFile('goldens/text_tile_card_dark_theme.png'),
      );
    });

    testWidgets('bar layout — with url arrow', (tester) async {
      _setViewSize(tester, const Size(400, 60));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final config = TileConfig(
        type: TileType.text,
        tileSize: TileSize.halfBar,
        title: 'Get in touch',
        colour: '#000000',
        url: 'mailto:hello@example.com',
      );

      await tester.pumpWidget(
        _light(TextTileRenderer(config: config), size: const Size(400, 60)),
      );

      await expectLater(
        find.byType(TextTileRenderer),
        matchesGoldenFile('goldens/text_tile_bar_with_arrow.png'),
      );
    });
  });

  group('ImageTileRenderer', () {
    testWidgets('no image path — renders empty', (tester) async {
      _setViewSize(tester, const Size(300, 200));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final config = TileConfig(
        type: TileType.image,
        tileSize: TileSize.halfCard,
        title: null,
        imagePath: null,
      );

      await tester.pumpWidget(_light(ImageTileRenderer(config: config)));
      await tester.pump();

      await expectLater(
        find.byType(ImageTileRenderer),
        matchesGoldenFile('goldens/image_tile_no_image.png'),
      );
    });

    testWidgets('with bundled asset and title scrim', (tester) async {
      _setViewSize(tester, const Size(300, 200));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final config = TileConfig(
        type: TileType.image,
        tileSize: TileSize.halfCard,
        title: 'My Project',
        imagePath: 'assets/bubbles.png',
      );

      await tester.pumpWidget(_light(ImageTileRenderer(config: config)));
      await tester.pump();

      await expectLater(
        find.byType(ImageTileRenderer),
        matchesGoldenFile('goldens/image_tile_with_scrim.png'),
      );
    });
  });

  group('LinkTileRenderer', () {
    testWidgets('card layout — light', (tester) async {
      _setViewSize(tester, const Size(300, 180));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final config = TileConfig(
        type: TileType.link,
        tileSize: TileSize.halfCard,
        title: 'My GitHub',
        url: 'https://github.com/builtbysid',
      );

      await tester.pumpWidget(
        _light(
          LinkTileRenderer(config: config, backgroundColour: Colors.white),
        ),
      );

      await expectLater(
        find.byType(LinkTileRenderer),
        matchesGoldenFile('goldens/link_tile_card_light.png'),
      );
    });

    testWidgets('bar layout — light', (tester) async {
      _setViewSize(tester, const Size(400, 60));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final config = TileConfig(
        type: TileType.link,
        tileSize: TileSize.halfBar,
        title: 'Connect on LinkedIn',
        url: 'https://linkedin.com/in/builtbysid',
      );

      await tester.pumpWidget(
        _light(
          LinkTileRenderer(
            config: config,
            backgroundColour: const Color(0xFFE8F4FD),
          ),
          size: const Size(400, 60),
        ),
      );

      await expectLater(
        find.byType(LinkTileRenderer),
        matchesGoldenFile('goldens/link_tile_bar_light.png'),
      );
    });

    testWidgets('tower layout — dark', (tester) async {
      _setViewSize(tester, const Size(200, 380));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final config = TileConfig(
        type: TileType.link,
        tileSize: TileSize.halfTower,
        title: 'All my code lives here.',
        url: 'https://github.com/builtbysid',
        imagePath: 'assets/git_graph.png',
      );

      await tester.pumpWidget(
        _dark(
          LinkTileRenderer(
            config: config,
            backgroundColour: const Color(0xFF1a1a2e),
          ),
          size: const Size(200, 380),
        ),
      );
      await tester.pump();

      await expectLater(
        find.byType(LinkTileRenderer),
        matchesGoldenFile('goldens/link_tile_tower_dark.png'),
      );
    });
  });
}
