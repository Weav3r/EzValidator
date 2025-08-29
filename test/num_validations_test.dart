import 'package:ez_validator/ez_validator.dart';
import 'package:ez_validator/src/validator/validator_error.dart';
import 'package:test/test.dart';

void main() {
  group('Number Validators', () {
    final requiredValidator = EzValidator<num?>().required().build();
    final optionalValidator =
        EzValidator<num?>(optional: true).required().build();
    final minValidator = EzValidator<num>().min(10).build();
    final maxValidator = EzValidator<num>().max(20).build();
    final betweenValidator = EzValidator<num>().min(10).max(20).build();
    final positiveValidator = EzValidator<num>().positive().build();
    final negativeValidator = EzValidator<num>().negative().build();
    final numberValidator = EzValidator<dynamic>().addValidation((v, [_]) {
      if (v == null || v is! num) {
        if (v is String) {
          try {
            num.parse(v);
            return (null, v);
          } catch (_) {
            return (const FieldError('Must be a number'), v);
          }
        }
        return (const FieldError('Must be a number'), v);
      }
      return (null, v);
    }).build();

    final notNumberValidator = EzValidator<dynamic>().addValidation((v, [_]) {
      if (v == null) return (const FieldError('Must not be null'), v);
      if (v is num) return (const FieldError('Must not be a number'), v);
      if (v is String) {
        try {
          num.parse(v);
          return (const FieldError('Must not be a number'), v);
        } catch (_) {
          return (null, v);
        }
      }
      return (null, v);
    }).build();

    final isIntValidator = EzValidator<dynamic>().addValidation((v, [_]) {
      if (v == null) return (const FieldError('Must be an integer'), v);
      if (v is int) return (null, v);
      if (v is String) {
        try {
          int.parse(v);
          return (null, v);
        } catch (_) {
          return (const FieldError('Must be an integer'), v);
        }
      }
      return (const FieldError('Must be an integer'), v);
    }).build();

    final isDoubleValidator = EzValidator<dynamic>().addValidation((v, [_]) {
      if (v == null) return (const FieldError('Must be a double'), v);
      if (v is double) return (null, v);
      if (v is String) {
        try {
          var parsed = double.parse(v);
          if (parsed.truncateToDouble() == parsed) {
            // Integer value as string, should fail
            return (const FieldError('Must be a double'), v);
          }
          return (null, v);
        } catch (_) {
          return (const FieldError('Must be a double'), v);
        }
      }
      return (const FieldError('Must be a double'), v);
    }).build();

    test('optional Validator', () {
      var result = optionalValidator(null);
      expect(result.$1, null, reason: 'null value');
      result = optionalValidator(15);
      expect(result.$1, null, reason: 'not null value');
    });
    test('required Validator', () {
      var result = requiredValidator(null);
      expect(result.$1, isA<FieldError>(), reason: 'null value');
      result = requiredValidator(15);
      expect(result.$1, null, reason: 'not null value');
    });
    test('min Validator', () {
      var result = minValidator(5);
      expect(result.$1, isA<FieldError>(), reason: 'Number less than min');
      result = minValidator(15);
      expect(result.$1, null, reason: 'Number greater than min');
    });
    test('max Validator', () {
      var result = maxValidator(25);
      expect(result.$1, isA<FieldError>(), reason: 'Number greater than max');
      result = maxValidator(15);
      expect(result.$1, null, reason: 'Number less than max');
    });

    test('between Validator', () {
      var result = betweenValidator(5);
      expect(result.$1, isA<FieldError>(), reason: 'Number less than min');
      result = betweenValidator(25);
      expect(result.$1, isA<FieldError>(), reason: 'Number greater than max');
      result = betweenValidator(15);
      expect(result.$1, null, reason: 'Number between min and max');
    });

    test('positive Validator', () {
      var result = positiveValidator(-15);
      expect(result.$1, isA<FieldError>(), reason: 'Negative int');
      result = positiveValidator(-1.5);
      expect(result.$1, isA<FieldError>(), reason: 'Negative double');
      result = positiveValidator(15);
      expect(result.$1, null, reason: 'Positive int');
      result = positiveValidator(1.5);
      expect(result.$1, null, reason: 'Positive double');
    });
    test('negative Validator', () {
      var result = negativeValidator(15);
      expect(result.$1, isA<FieldError>(), reason: 'Positive int');
      result = negativeValidator(1.5);
      expect(result.$1, isA<FieldError>(), reason: 'Positive double');
      result = negativeValidator(-15);
      expect(result.$1, null, reason: 'Negative int');
      result = negativeValidator(-1.5);
      expect(result.$1, null, reason: 'Negative double');
    });
    test('number Validator', () {
      var result = numberValidator(15);
      expect(result.$1, null, reason: 'Number as int');
      result = numberValidator(15.5);
      expect(result.$1, null, reason: 'Number as double');
      result = numberValidator(-15);
      expect(result.$1, null, reason: 'Number as N int');
      result = numberValidator(-1.1);
      expect(result.$1, null, reason: 'Number as N double');
      result = numberValidator("10");
      expect(result.$1, null, reason: 'String as number int');
      result = numberValidator("1.1");
      expect(result.$1, null, reason: 'String as P double');
      result = numberValidator("-1.1");
      expect(result.$1, null, reason: 'String as N double');
      result = numberValidator("0");
      expect(result.$1, null, reason: 'String as number');
      result = numberValidator("X");
      expect(result.$1, isA<FieldError>(), reason: 'String as N double');
    });
    test('notNumber Validator', () {
      var result = notNumberValidator(15);
      expect(result.$1, isA<FieldError>(), reason: 'Number as int');
      result = notNumberValidator(15.5);
      expect(result.$1, isA<FieldError>(), reason: 'Number as double');
      result = notNumberValidator(-15);
      expect(result.$1, isA<FieldError>(), reason: 'Number as N int');
      result = notNumberValidator(-1.1);
      expect(result.$1, isA<FieldError>(), reason: 'Number as N double');
      result = notNumberValidator("10");
      expect(result.$1, isA<FieldError>(), reason: 'String as number int');
      result = notNumberValidator("1.1");
      expect(result.$1, isA<FieldError>(), reason: 'String as P double');
      result = notNumberValidator("-1.1");
      expect(result.$1, isA<FieldError>(), reason: 'String as N double');
      result = notNumberValidator("0");
      expect(result.$1, isA<FieldError>(), reason: 'String as number');
      result = notNumberValidator("X");
      expect(result.$1, null, reason: 'String as N double');
    });

    test('isInt Validator', () {
      expect(isIntValidator(15).$1, isNull, reason: 'Number as int');
      expect(isIntValidator(15.5).$1, isNotNull, reason: 'Number as double');
      expect(isIntValidator(-15).$1, isNull, reason: 'Number as N int');
      expect(isIntValidator(-1.1).$1, isNotNull, reason: 'Number as N double');
      expect(isIntValidator("10").$1, isNull, reason: 'String as number int');
      expect(isIntValidator("1.1").$1, isNotNull, reason: 'String as P double');
      expect(isIntValidator("-1.1").$1, isNotNull,
          reason: 'String as N double');
      expect(isIntValidator("0").$1, isNull, reason: 'String as number');
      expect(isIntValidator("X").$1, isNotNull, reason: 'String as N double');
    });

    test('isDouble Validator', () {
      expect(isDoubleValidator(15).$1, isNotNull, reason: 'Number as int');
      expect(isDoubleValidator(15.5).$1, isNull, reason: 'Number as double');
      expect(isDoubleValidator(-15).$1, isNotNull, reason: 'Number as N int');
      expect(isDoubleValidator(-1.1).$1, isNull, reason: 'Number as N double');
      expect(
        isDoubleValidator("10"),
        isNotNull,
        reason: 'String as number int',
      );
      expect(isDoubleValidator("1.1").$1, isNull, reason: 'String as P double');
      expect(isDoubleValidator("-1.1").$1, isNull,
          reason: 'String as N double');
      expect(isDoubleValidator("0").$1, isNotNull, reason: 'String as number');
      expect(isDoubleValidator("X").$1, isNotNull,
          reason: 'String as N double');
    });
  });
}
