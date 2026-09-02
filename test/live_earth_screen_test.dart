import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mausam_app/features/advanced/earth/presentation/screens/live_earth_screen.dart';

void main() {
  group('LiveEarthScreen Responsive & Zero Overflow Tests', () {
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
      testWidgets(
          'Renders LiveEarthScreen on $width px width with zero overflow',
          (WidgetTester tester) async {
        tester.view.physicalSize = Size(width, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: LiveEarthScreen(),
            ),
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Live Earth & 4D Weather'), findsOneWidget);
        expect(find.text('NOW'), findsOneWidget);

        // Tap 2D/3D toggle button
        await tester.tap(find.byIcon(Icons.public_rounded));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(tester.takeException(), isNull,
            reason: 'Overflow or exception caught on width $width');
      });
    }

    testWidgets(
        'Renders LiveEarthScreen under 1.5x font scaling with zero overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: ProviderScope(
            child: MaterialApp(
              home: LiveEarthScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(tester.takeException(), isNull,
          reason: 'Overflow or exception caught under 1.5x font scaling');
    });
  });
}
