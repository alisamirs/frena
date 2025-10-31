// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frena/main.dart';

void main() {
  testWidgets('App initializes and shows currency list', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app bar shows Frena title
    expect(find.text('Frena - USD'), findsOneWidget);

    // Verify that floating action button is present
    expect(find.byIcon(Icons.currency_exchange), findsOneWidget);
    
    // Verify that settings and refresh buttons are present
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });

  testWidgets('Search field is present', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Look for search hint text
    expect(find.text('Search currencies...'), findsOneWidget);
  });

  testWidgets('Favorites filter chip is present', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Look for favorites chip
    expect(find.text('Favorites'), findsOneWidget);
  });
}
