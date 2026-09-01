import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mausam_app/features/advanced/cyclone/presentation/screens/cyclone_tracker_screen.dart';

void main() {
  group('CycloneTrackerScreen Responsive & Zero Overflow Tests', () {
    final deviceWidths = [
      320.0,
      360.0,
      375.0,
      390.0,
      393.0,
      412.0,
      414.0,
      430.0,
      480.0
    ];

    for (final width in deviceWidths) {
      testWidgets('Renders CycloneTrackerScreen on $width px width with zero overflow',
          (WidgetTester tester) async {
        tester.view.physicalSize = Size(width, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: CycloneTrackerScreen(),
            ),
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        expect(find.text('Cyclone Tracker'), findsOneWidget);
        expect(find.text('Cyclone REMAL'), findsOneWidget);

        // Scroll to bottom to verify all cards & bottom source badge render with zero overflow
        await tester.dragUntilVisible(
          find.text('High Threat Coastal Regions'),
          find.byType(ListView),
          const Offset(0, -200),
        );
        await tester.pumpAndSettle();

        expect(find.text('High Threat Coastal Regions'), findsOneWidget);

        expect(tester.takeException(), isNull,
            reason: 'Overflow or exception caught on width $width');
      });
    }

    testWidgets('Renders CycloneTrackerScreen under 1.5x font scaling with zero overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: ProviderScope(
            child: MaterialApp(
              home: CycloneTrackerScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.text('High Threat Coastal Regions'),
        find.byType(ListView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull,
          reason: 'Overflow or exception caught under 1.5x font scaling');
    });
  });
}


