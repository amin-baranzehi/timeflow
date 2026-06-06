import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:timeflow/main.dart';

void main() {
  testWidgets('TimeFlow tracker smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Focus Time'), findsOneWidget);
    await tester.tap(find.byTooltip('New activity'));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('New Activity'), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Note'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
