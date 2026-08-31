import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mausam_app/features/advanced/disaster/presentation/screens/disaster_detail_screen.dart';

void main() {
  group('DisasterDetailScreen Responsive & Zero Overflow Tests', () {
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
      testWidgets('Renders DisasterDetailScreen on $width px width with zero overflow',
          (WidgetTester tester) async {
        tester.view.physicalSize = Size(width, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: DisasterDetailScreen(disasterId: 'disaster-cyclone-1'),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Disaster Advisory Detail'), findsOneWidget);

        // Scroll to bottom to verify all cards & bottom source badge render with zero overflow
        await tester.drag(find.byType(ListView), const Offset(0, -600));
        await tester.pumpAndSettle();

        expect(find.text('Preparedness Checklist'), findsOneWidget);

        expect(tester.takeException(), isNull,
            reason: 'Overflow or exception caught on width $width');
      });
    }

    testWidgets('Renders DisasterDetailScreen under 1.5x font scaling with zero overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: const ProviderScope(
            child: MaterialApp(
              home: DisasterDetailScreen(disasterId: 'disaster-cyclone-1'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull,
          reason: 'Overflow or exception caught under 1.5x font scaling');
    });
  });
}
