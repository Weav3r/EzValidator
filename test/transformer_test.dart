import 'package:ez_validator/ez_validator.dart';
import 'package:ez_validator/src/validator/validator_error.dart';
import 'package:test/test.dart';

void main() {
  group('Transform Method Tests', () {
    test('Trimming whitespace before validation', () {
      final validator = EzValidator<String>()
          .transform((value) => value?.trim() ?? value)
          .minLength(
              5, "Input must be at least 5 characters long after trimming.")
          .build();

      expect(validator("  hello  ").$1, isNull);
      expect(validator("  hi  ").$1, isNotNull);
    });

    test('Transforming string to int before validation', () {
      final validator = EzValidator<dynamic>()
          .transform((value) => int.tryParse(value) ?? 0)
          .addMethod((value, [_]) => value > 0
              ? (null, value)
              : (const FieldError('Value must be a positive number'), value))
          .build();

      expect(validator("123").$1, isNull);
      expect(validator("abc").$1, isNotNull);
    });

    test('Must be a string empty', () {
      final validator = EzValidator<String>()
          .transform((value) => "")
          .addMethod((str, [_]) => str!.isNotEmpty
              ? (null, str)
              : (const FieldError("Must be a string empty"), str))
          .build();

      expect(validator("XXXXXXX").$1, isNotNull);
    });

    test('Must Not be a string empty', () {
      final validator = EzValidator<String>()
          .transform((value) => '--$value--')
          .addMethod((str, [_]) => str!.contains('--')
              ? (null, str)
              : (const FieldError('Must Not be a string empty'), str))
          .build();

      expect(validator("IHEB").$1, isNull);
    });
  });
}
