import 'package:flutter_test/flutter_test.dart';
import 'package:rising_star_crypto_app/common/helpers.dart';

void main() {
  group('isSameDay', () {
    test('not same day', () {
      final dayA = DateTime(2020, 1, 1);
      final dayB = DateTime(2021, 1, 1);
      expect(Helpers.isSameDay(dayA, dayB), false);
    });

    test('same day', () {
      final dayA = DateTime(2020, 1, 1);
      final dayB = DateTime(2020, 1, 1);
      expect(Helpers.isSameDay(dayA, dayB), true);
    });

    test('same day, different time', () {
      final dayA = DateTime(2020, 1, 1, 1);
      final dayB = DateTime(2020, 1, 1, 2);
      expect(Helpers.isSameDay(dayA, dayB), true);
    });
  });

  group('getDailyValuesWihtinRange', () {});
}
