import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rising_star_crypto_app/common/date_value_info.dart';
import 'package:rising_star_crypto_app/models/date_value_data.dart';

void main() {
  testWidgets('title, date, value, symbol', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DateValueInfo(
          title: 'title',
          dateValue: DateValueData(DateTime(2021, 1, 1), 100.123),
          valueSymbol: '€',
        ),
      ),
    );
    expect(find.text('100.12 €'), findsOneWidget);
    expect(find.text('1.1.2021'), findsOneWidget);
    expect(find.text('title'), findsOneWidget);
  });
  testWidgets('only date and value', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DateValueInfo(
          dateValue: DateValueData(DateTime(2021, 1, 1), 100.123),
        ),
      ),
    );
    expect(find.text('100.12'), findsOneWidget);
    expect(find.text('1.1.2021'), findsOneWidget);
  });

  testWidgets('no data, null date', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DateValueInfo(
          dateValue: null,
        ),
      ),
    );
    expect(find.text('No Data'), findsWidgets);
  });
}
