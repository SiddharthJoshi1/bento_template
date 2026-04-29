import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bento_template/presentation/widgets/bento_grid/tiles/renderers/section_title_renderer.dart';
import 'package:bento_template/presentation/widgets/bento_grid/tiles/renderers/text_tile_renderer.dart';
import 'package:bento_template/domain/entities/tile_config.dart';

// Minimal wrapper that provides MediaQuery + Theme — enough for
// ResponsiveText and colour helpers without the full app shell.
Widget _wrap(Widget child, {Size size = const Size(1200, 800)}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: Scaffold(body: SizedBox(width: 300, height: 300, child: child)),
    ),
  );
}

void main() {
  group('SectionTitleRenderer', () {
    TileConfig makeConfig({String? title}) => TileConfig(
          type: TileType.sectionTitle,
          tileSize: TileSize.fullBar,
          title: title,
        );

    testWidgets('renders title text', (tester) async {
      await tester.pumpWidget(_wrap(SectionTitleRenderer(config: makeConfig(title: 'Projects'))));
      expect(find.text('Projects'), findsOneWidget);
    });

    testWidgets('renders nothing when title is null', (tester) async {
      await tester.pumpWidget(_wrap(SectionTitleRenderer(config: makeConfig(title: null))));
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('renders nothing when title is empty', (tester) async {
      await tester.pumpWidget(_wrap(SectionTitleRenderer(config: makeConfig(title: ''))));
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('aligns content to bottom left', (tester) async {
      await tester.pumpWidget(_wrap(SectionTitleRenderer(config: makeConfig(title: 'Hello'))));
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.alignment, Alignment.bottomLeft);
    });
  });

  group('TextTileRenderer', () {
    TileConfig makeCard({String? title, String? colour, String? url}) => TileConfig(
          type: TileType.text,
          tileSize: TileSize.halfCard,
          title: title,
          colour: colour,
          url: url,
        );

    TileConfig makeBar({String? title, String? colour, String? url}) => TileConfig(
          type: TileType.text,
          tileSize: TileSize.halfBar,
          title: title,
          colour: colour,
          url: url,
        );

    testWidgets('card layout renders title text', (tester) async {
      await tester.pumpWidget(_wrap(TextTileRenderer(config: makeCard(title: 'Hello world'))));
      expect(find.text('Hello world'), findsOneWidget);
    });

    testWidgets('bar layout renders title text', (tester) async {
      await tester.pumpWidget(_wrap(TextTileRenderer(config: makeBar(title: 'Bar title'))));
      expect(find.text('Bar title'), findsOneWidget);
    });

    testWidgets('bar layout shows arrow icon when url is set', (tester) async {
      await tester.pumpWidget(
        _wrap(TextTileRenderer(config: makeBar(title: 'Link', url: 'https://example.com'))),
      );
      expect(find.byIcon(Icons.arrow_outward_sharp), findsOneWidget);
    });

    testWidgets('bar layout hides arrow icon when url is null', (tester) async {
      await tester.pumpWidget(
        _wrap(TextTileRenderer(config: makeBar(title: 'No link'))),
      );
      expect(find.byIcon(Icons.arrow_outward_sharp), findsNothing);
    });

    testWidgets('card layout shows bubble chart icon', (tester) async {
      await tester.pumpWidget(_wrap(TextTileRenderer(config: makeCard(title: 'Card'))));
      expect(find.byIcon(Icons.bubble_chart_outlined), findsOneWidget);
    });

    testWidgets('renders without error when title is null', (tester) async {
      await tester.pumpWidget(_wrap(TextTileRenderer(config: makeCard(title: null))));
      expect(find.byType(TextTileRenderer), findsOneWidget);
    });

    testWidgets('uses custom colour from config', (tester) async {
      // Just verify it renders — colour correctness is a golden concern
      await tester.pumpWidget(
        _wrap(TextTileRenderer(config: makeCard(title: 'Coloured', colour: '#f9aa3a'))),
      );
      expect(find.text('Coloured'), findsOneWidget);
    });
  });
}
