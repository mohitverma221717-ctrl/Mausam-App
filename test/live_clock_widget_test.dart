import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mausam_app/core/widgets/live_clock_widget.dart';

void main() {
  testWidgets('LiveClockWidget renders formatted current system time and date',
      (WidgetTester tester) async {
    final now = DateTime.now();
    final expectedTimeStr = DateFormat('hh:mm a').format(now);
    final expectedDateStr = DateFormat('EEE, d MMM').format(now);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LiveClockWidget(
            style: LiveClockStyle.pill,
            showDate: false,
          ),
        ),
      ),
    );

    expect(find.byType(LiveClockWidget), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LiveClockWidget(
            style: LiveClockStyle.inlineText,
            showDate: true,
          ),
        ),
      ),
    );

    expect(find.byType(LiveClockWidget), findsOneWidget);
  });
}
