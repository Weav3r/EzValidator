import 'package:ez_validator/src/validator/ez_validator_builder.dart';
import 'package:ez_validator/src/validator/validator_error.dart';

extension NumValidatorExtensions<T> on EzValidator<T> {
  /// Checks if the value is a minimum of [min]
  /// [message] is the message to return if the validation fails
  EzValidator<T> min(num min, [String? message]) {
    return addValidation((v, [_]) {
      if (v is num) {
        return v < min
            ? FieldError(message ?? EzValidator.globalLocale.min('$v', min, label))
            : null;
      }

      if (v is String) {
        return num.tryParse(v) != null && num.parse(v) < min
            ? FieldError(message ?? EzValidator.globalLocale.min('$v', min, label))
            : null;
      }

      return const FieldError('Invalid type for min comparison');
    });
  }

  /// Checks if the value is a maximum of [max]
  /// [message] is the message to return if the validation fails
  EzValidator<T> max(num max, [String? message]) => addValidation((v, [_]) {
        if (v is num) {
          return v > max
              ? FieldError(message ?? EzValidator.globalLocale.max('$v', max, label))
              : null;
        }

        if (v is String) {
          return num.tryParse(v) != null && num.parse(v) > max
              ? FieldError(message ?? EzValidator.globalLocale.max('$v', max, label))
              : null;
        }

        return const FieldError('Invalid type for max comparison');
      });

  /// Checks if the value is between [min] and [max]
  /// [message] is the message to return if the validation fails
  EzValidator<T> positive([String? message]) => addValidation((v, [_]) {
        if (v is num) {
          return v < 0
              ? FieldError(
                  message ?? EzValidator.globalLocale.positive('$v', label))
              : null;
        }

        if (v is String) {
          return num.tryParse(v) != null && num.parse(v) < 0
              ? FieldError(
                  message ?? EzValidator.globalLocale.positive('$v', label))
              : null;
        }

        return const FieldError('Invalid type for positive comparison');
      });

  /// Checks if the value is negative
  /// [message] is the message to return if the validation fails
  EzValidator<T> negative([String? message]) => addValidation((v, [_]) {
        if (v is num) {
          return v > 0
              ? FieldError(
                  message ?? EzValidator.globalLocale.negative('$v', label))
              : null;
        }

        if (v is String) {
          return num.tryParse(v) != null && num.parse(v) > 0
              ? FieldError(
                  message ?? EzValidator.globalLocale.negative('$v', label))
              : null;
        }
        return const FieldError('Invalid type for negative comparison');
      });

  /// Checks if the value is a number
  /// [message] is the message to return if the validation fails
  EzValidator<T> number([String? message]) => addValidation((v, [_]) {
        if (v is num) {
          return null;
        }
        return num.tryParse(v.toString()) != null
            ? null
            : FieldError(message ?? EzValidator.globalLocale.number('$v', label));
      });

  /// Checks if the value is an integer
  /// [message] is the message to return if the validation fails
  EzValidator<T> isInt([String? message]) => addValidation((v, [_]) {
        if (v is int) {
          return null;
        }

        return int.tryParse(v.toString()) != null
            ? null
            : FieldError(message ?? EzValidator.globalLocale.isInt('$v', label));
      });

  /// Checks if the value is a double
  /// [message] is the message to return if the validation fails
  EzValidator<T> isDouble([String? message]) => addValidation((v, [_]) {
        if (v is double) {
          return null;
        }

        if (v is int) {
          return FieldError(
              message ?? EzValidator.globalLocale.isDouble('$v', label));
        }

        if (int.tryParse(v.toString()) != null) {
          return FieldError(
              message ?? EzValidator.globalLocale.isDouble('$v', label));
        }

        return double.tryParse(v.toString()) != null
            ? null
            : FieldError(
                message ?? EzValidator.globalLocale.isDouble('$v', label));
      });

  /// Checks if the value is not a number
  /// [message] is the message to return if the validation fails
  EzValidator<T> notNumber([String? message]) => addValidation((v, [_]) {
        if (v is num) {
          return FieldError(
              message ?? EzValidator.globalLocale.notNumber('$v', label));
        }
        return num.tryParse(v.toString()) == null
            ? null
            : FieldError(
                message ?? EzValidator.globalLocale.notNumber('$v', label));
      });
}
