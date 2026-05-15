import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('HireIn app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HireInApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
