import 'package:ez_validator/src/validator/ez_validator_builder.dart';
import 'package:ez_validator/src/validator/validator_error.dart';

extension NumValidatorExtensions<T> on EzValidator<T> {
  /// Checks if the value is a minimum of [min]
  /// [message] is the message to return if the validation fails
  EzValidator<T> min(num min, [String? message]) {
    return addValidation((v, [_]) {
      if (v is num) {
        return v < min
            ? (
                FieldError(
                    message ?? EzValidator.globalLocale.min('$v', min, label)),
                v
              )
            : (null, v);
      }

      if (v is String) {
        final parsed = num.tryParse(v);
        if (parsed != null) {
          return parsed < min
              ? (
                  FieldError(message ??
                      EzValidator.globalLocale.min('$v', min, label)),
                  v
                )
              : (null, parsed as T);
        }
      }

      return (const FieldError('Invalid type for min comparison'), v);
    });
  }

  /// Checks if the value is a maximum of [max]
  /// [message] is the message to return if the validation fails
  EzValidator<T> max(num max, [String? message]) => addValidation((v, [_]) {
        if (v is num) {
          return v > max
              ? (
                  FieldError(message ??
                      EzValidator.globalLocale.max('$v', max, label)),
                  v
                )
              : (null, v);
        }

        if (v is String) {
          final parsed = num.tryParse(v);
          if (parsed != null) {
            return parsed > max
                ? (
                    FieldError(message ??
                        EzValidator.globalLocale.max('$v', max, label)),
                    v
                  )
                : (null, parsed as T);
          }
        }

        return (const FieldError('Invalid type for max comparison'), v);
      });

  /// Checks if the value is positive
  /// [message] is the message to return if the validation fails
  EzValidator<T> positive([String? message]) => addValidation((v, [_]) {
        if (v is num) {
          return v < 0
              ? (
                  FieldError(message ??
                      EzValidator.globalLocale.positive('$v', label)),
                  v
                )
              : (null, v);
        }

        if (v is String) {
          final parsed = num.tryParse(v);
          if (parsed != null) {
            return parsed < 0
                ? (
                    FieldError(message ??
                        EzValidator.globalLocale.positive('$v', label)),
                    v
                  )
                : (null, parsed as T);
          }
        }

        return (const FieldError('Invalid type for positive comparison'), v);
      });

  /// Checks if the value is negative
  /// [message] is the message to return if the validation fails
  EzValidator<T> negative([String? message]) => addValidation((v, [_]) {
        if (v is num) {
          return v > 0
              ? (
                  FieldError(message ??
                      EzValidator.globalLocale.negative('$v', label)),
                  v
                )
              : (null, v);
        }

        if (v is String) {
          final parsed = num.tryParse(v);
          if (parsed != null) {
            return parsed > 0
                ? (
                    FieldError(message ??
                        EzValidator.globalLocale.negative('$v', label)),
                    v
                  )
                : (null, parsed as T);
          }
        }

        return (const FieldError('Invalid type for negative comparison'), v);
      });

  /// Checks if the value is an integer
  /// [message] is the message to return if the validation fails
  EzValidator<T> integer([String? message]) => addValidation((v, [_]) {
        if (v is int) {
          return (null, v);
        }

        if (v is double) {
          return v.truncateToDouble() == v
              ? (null, v)
              : (
                  FieldError(
                      message ?? EzValidator.globalLocale.integer('$v', label)),
                  v
                );
        }

        if (v is String) {
          final parsed = int.tryParse(v);
          if (parsed != null) {
            return (null, parsed as T);
          }
          final dblVal = double.tryParse(v);
          if (dblVal != null && dblVal.truncateToDouble() == dblVal) {
            return (null, dblVal as T);
          }
          return (
            FieldError(
                message ?? EzValidator.globalLocale.integer('$v', label)),
            v
          );
        }

        return (const FieldError('Invalid type for integer validation'), v);
      });

  /// Checks if the value is a decimal
  /// [message] is the message to return if the validation fails
  EzValidator<T> decimal([String? message]) => addValidation((v, [_]) {
        if (v is double) {
          return (null, v);
        }

        if (v is String) {
          final parsed = double.tryParse(v);
          if (parsed != null) {
            return (null, parsed as T);
          }
          return (
            FieldError(
                message ?? EzValidator.globalLocale.decimal('$v', label)),
            v
          );
        }

        return (const FieldError('Invalid type for decimal validation'), v);
      });
}
