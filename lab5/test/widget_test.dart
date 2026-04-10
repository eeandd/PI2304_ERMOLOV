import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab5/main.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
  }

  testWidgets('title and simple list by default', (WidgetTester tester) async {
    await pumpApp(tester);

    expect(find.text('Список элементов'), findsOneWidget);
    expect(find.text('Простой'), findsOneWidget);
    expect(find.text('Бесконечный'), findsOneWidget);
    expect(find.text('Степени'), findsOneWidget);

    expect(find.text('0000'), findsOneWidget);
    expect(find.text('0001'), findsOneWidget);
    expect(find.text('0010'), findsOneWidget);
    expect(find.text('Строка 0'), findsNothing);
    expect(find.text('2 ^ 0 = 1'), findsNothing);
  });

  testWidgets('infinity list', (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Бесконечный'));
    await tester.pumpAndSettle();

    expect(find.text('Строка 0'), findsOneWidget);
    expect(find.text('0000'), findsNothing);
    expect(find.text('2 ^ 0 = 1'), findsNothing);
  });

  testWidgets('math list', (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Степени'));
    await tester.pumpAndSettle();

    expect(find.text('2 ^ 0 = 1'), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);
    expect(find.text('0000'), findsNothing);
  });
}
