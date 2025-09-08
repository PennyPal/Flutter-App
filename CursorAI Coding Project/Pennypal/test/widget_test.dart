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
    expect(find.text('PennyPal'), findsOneWidget);
    expect(find.text('Make budgeting fun'), findsOneWidget);
  });
}