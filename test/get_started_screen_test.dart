import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mausam_app/features/onboarding/presentation/screens/get_started_screen.dart';

void main() {
  group('GetStartedScreen Name Input & Navigation Tests', () {
    testWidgets('Renders name input field, title, and continue button with zero overflow',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GetStartedScreen(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text("Let's Get Started"), findsOneWidget);
      expect(
        find.text('Tell us who you are to personalize your daily weather forecast.'),
        findsOneWidget,
      );
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      // Enter user name
      await tester.enterText(find.byType(TextField), 'Mohit Verma');
      await tester.pump();

      expect(find.text('Mohit Verma'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
