import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bento_template/presentation/widgets/bento_states/bento_loading_screen.dart';

void main() {
  group('BentoLoadingScreen', () {
    testWidgets('renders 16 tiles', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: BentoLoadingScreen()),
      );

      // AnimatedBuilder contains 16 tiles in the GridView
      expect(find.byType(GridView), findsOneWidget);

      // Pump one frame to start animations
      await tester.pump();

      // 16 _BentoTileShape instances rendered
      expect(find.byType(DecoratedBox), findsNWidgets(16));
    });

    testWidgets('shows Loading text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: BentoLoadingScreen()),
      );
      await tester.pump();

      expect(find.text('Loading'), findsOneWidget);
    });

    testWidgets('is centred on screen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: BentoLoadingScreen()),
      );
      await tester.pump();

      final center = find.byType(Center);
      expect(center, findsWidgets);
    });

    testWidgets('disposes without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: BentoLoadingScreen()),
      );
      await tester.pump();
      // Removing the widget triggers dispose — no exception should be thrown
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    });
  });
}
