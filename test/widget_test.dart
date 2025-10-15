// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:movie_browsing_app/main.dart';
import 'package:movie_browsing_app/theme_management/theme_enum.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
        const MovieBrowsingApp(initialTheme: ThemeOption.system)
    );


    expect(find.text('Home'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);


    expect(find.text('Top Indian Movies'), findsOneWidget);
    expect(find.text('Popular Shows'), findsOneWidget);
    expect(find.text('Globally Popular Movies'), findsOneWidget);

  });
}
