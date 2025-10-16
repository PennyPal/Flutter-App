import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pennypal/app.dart';

void main() {
  testWidgets('PennyPal app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: PennyPalApp(),
      ),
    );

  // Verify that the splash screen shows up.
  // The splash currently displays 'PENNY PAL' and the tagline 'Your financial friend'.
  expect(find.text('PENNY PAL'), findsOneWidget);
  expect(find.text('Your financial friend'), findsOneWidget);
  });
}