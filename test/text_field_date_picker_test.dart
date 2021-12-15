import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rising_star_crypto_app/common/text_field_date_picker.dart';

void main() {
  setUp(() {});
  testWidgets('onPressed callback', (WidgetTester tester) async {
    var pressed = false;
    var initialDate = DateTime(2020, 1, 1);

    await tester.pumpWidget(
      Builder(builder: (context) {
        return MaterialApp(
          home: Scaffold(
            body: TextFieldDatePicker(
              initialDate: initialDate,
              onPressed: (DateTime date) {
                pressed = true;
              },
            ),
          ),
        );
      }),
    );

    final button = find.byType(InkWell);
    expect(button, findsOneWidget);
    // Wait for datepicker
    await tester.tap(button);
    await tester.pumpAndSettle();
    final datePickerButton = find.byType(TextButton);
    expect(datePickerButton, findsWidgets);
    await tester.tap(datePickerButton.last);
    await tester.pumpAndSettle();
    expect(datePickerButton, findsNothing);
    expect(pressed, true);
  });
}
