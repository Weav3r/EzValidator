import 'package:test/test.dart';
import 'package:ez_validator/ez_validator.dart';

void main() {
  group('fromRaw<R> coercion', () {
    test('DateTime from string', () {
      final dateValidator = EzValidator<DateTime>()
          .fromRaw(DateTime.parse)
          .maxDate(DateTime(2025, 01, 01))
          .build(); // <-- build returns the function

      final (err1, val1) = dateValidator("2024-12-31");
      expect(err1, isNull);
      expect(val1, isA<DateTime>());
      expect(val1!.year, 2024);

      final (err2, val2) = dateValidator("2030-01-01");
      expect(err2, isNotNull);
      expect(val2, isA<DateTime>());
    });

    test('Int from string', () {
      final intValidator = EzValidator<int>()
          .fromRaw((String raw) => int.parse(raw))
          .min(18)
          .build();

      final (err1, val1) = intValidator(20);
      expect(err1, isNull);
      expect(val1, 20);

      final (err2, val2) = intValidator("25");
      expect(err2, isNull);
      expect(val2, 25);

      final (err3, val3) = intValidator("abc");
      expect(err3, isNotNull);
      expect(val3, isNull);
    });
  });
}
