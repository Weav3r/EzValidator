import 'package:ez_validator/ez_validator.dart';
import 'package:ez_validator/src/validator/validator_error.dart';
import 'package:test/test.dart';

void main() {
  group('Array Validator Tests', () {
    final validator = EzValidator<List<dynamic>>().required().addMethod((v) {
      if (v == null) return null;
      for (var item in v) {
        if (item is! num || item < 0) {
          return const FieldError('The field must be a positive number');
        }
      }
      return null;
    });

    final numString = EzValidator<List<dynamic>>().required().addMethod((v) {
      if (v == null) return null;
      for (var item in v) {
        if (num.tryParse(item) == null || num.parse(item) < 0) {
          return const FieldError('The field must be a positive number');
        }
      }
      return null;
    });

    test('Valid array should pass validation', () {
      var result = validator.validate([1, 2, 3, 4, 5]);
      expect(result, isNull);
    });

    test('Array with negative numbers should fail validation', () {
      var result = validator.validate([1, -2, 3, 4, -5]);
      expect(result, isNotNull);
    });

    test('Empty array should pass validation', () {
      var result = validator.validate([]);
      expect(result, isNull);
    });

    test('Null array should pass validation', () {
      var result = validator.validate(null);
      expect(result, isNull);
    });

    test('Num String array should pass validation', () {
      var result = numString.validate(['1', '2', '3', '4', '5']);
      expect(result, isNull);
    });

    test('Array with non-numeric values should fail validation', () {
      var result = validator.validate([1, 'two', 3, 4.5]);
      expect(result, isNotNull);
    });
  });
}
