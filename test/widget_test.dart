// Basic Flutter widget test for Animigo

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animigo/main.dart';

void main() {
  testWidgets('App starts successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AnimigoApp());

    // Verify that splash screen appears
    expect(find.byType(AnimigoApp), findsOneWidget);
  });
}
