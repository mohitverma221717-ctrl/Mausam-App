import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mausam_app/features/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  group('OnboardingScreen Responsive & Zero Pixel Overflow Tests', () {
    final testViewports = [
      const Size(320, 480), // Ultra small legacy / short device
      const Size(320, 568), // iPhone SE 1st gen
      const Size(360, 640), // Standard compact Android
      const Size(375, 667), // iPhone 8 / SE 2nd gen
      const Size(390, 844), // iPhone 12/13/14
      const Size(393, 852), // iPhone 15/16 Pro
      const Size(412, 915), // Pixel 7
      const Size(430, 932), // iPhone Pro Max
      const Size(480, 800), // Standard medium display
      const Size(360, 520), // Extreme short height test
    ];

    for (final size in testViewports) {
      testWidgets('Renders OnboardingScreen on ${size.width}x${size.height} with zero pixel overflow',
          (WidgetTester tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const MaterialApp(
            home: OnboardingScreen(),
          ),
        );

        await tester.pump(const Duration(milliseconds: 100));

        // Verify key widgets are present
        expect(find.text('MAUSAM'), findsOneWidget);
        expect(find.text('Skip'), findsOneWidget);
        expect(find.text('Personalized Weather For You'), findsOneWidget);
        expect(find.text('Smart Tailoring'), findsOneWidget);
        expect(find.text('Next'), findsOneWidget);

        // Ensure zero layout overflow errors occurred
        expect(tester.takeException(), isNull);
      });
    }
  });
}
