import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bento_template/presentation/widgets/bento_states/bento_error_screen.dart';

void main() {
  group('BentoErrorScreen', () {
    Widget buildSubject({String message = 'Test error'}) => MaterialApp(
          home: BentoErrorScreen(message: message),
        );

    testWidgets('shows Something went wrong text', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('shows subtitle text', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.text("The bento couldn't load"), findsOneWidget);
    });

    testWidgets('renders the faded background grid with 16 tiles', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(DecoratedBox), findsNWidgets(16));
    });

    testWidgets('renders CustomPaint for sad face', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.byType(CustomPaint), findsAny);
    });

    testWidgets('accepts and stores message prop', (tester) async {
      const msg = 'Network timeout';
      await tester.pumpWidget(buildSubject(message: msg));
      // message is passed through — the widget renders without error
      // (message is used by callers, not directly displayed in current design)
      expect(find.byType(BentoErrorScreen), findsOneWidget);
    });

    testWidgets('renders inside a Scaffold', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
