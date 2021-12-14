import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rising_star_crypto_app/common/text_field_date_picker.dart';

class MockDatePicker extends Mock {}

@GenerateMocks([DatePickerDialog])
void main() {
  setUp(() {});

  Future<void> pumpTextFieldDatePicker(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TextFieldDatePicker(
            onPressed: (date) {},
          ),
        ),
      ),
    );
  }

  testWidgets('onPressed callback', (WidgetTester tester) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: TextFieldDatePicker(
          onPressed: (DateTime date) {
            pressed = true;
          },
        ),
      ),
    );
    final button = find.byType(InkWell);
    expect(button, findsOneWidget);
    await tester.tap(button);
    expect(pressed, pressed);
  });
}
