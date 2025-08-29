import 'package:ez_validator/src/validator/ez_validator_builder.dart';
import 'package:ez_validator/src/validator/validator_error.dart';

extension DateValidatorExtensions<T> on EzValidator<T> {
  /// Checks if the value is a date
  EzValidator<T> date([String? message]) => addValidation((v, [_]) {
        if (v is DateTime) {
          return (null, v as T);
        }

        if (v is String) {
          final parsed = DateTime.tryParse(v);
          if (parsed != null) {
            return (
              null,
              v as T
            ); // Keep the string if that's what we're validating
          }
        } else {
          final parsed = DateTime.tryParse(v.toString());
          if (parsed != null) {
            return (null, parsed as T);
          }
        }

        return (
          FieldError(message ?? EzValidator.globalLocale.date('$v', label)),
          v
        );
      });

  /// Checks if the value is is after [date]
  /// [message] is the message to return if the validation fails
  EzValidator<T> minDate(DateTime date, [String? message]) =>
      addValidation((v, [_]) {
        DateTime? parsed;
        if (v is DateTime) {
          parsed = v;
        } else {
          parsed = DateTime.tryParse(v.toString());
          if (parsed == null) {
            return (
              FieldError(message ?? EzValidator.globalLocale.date('$v', label)),
              v
            );
          }
        }

        return parsed.isAfter(date) || parsed.isAtSameMomentAs(date)
            ? (null, parsed as T)
            : (
                FieldError(message ??
                    EzValidator.globalLocale.dateMin('$v', date, label)),
                v
              );
      });

  /// Checks if the value is is before [date]
  /// [message] is the message to return if the validation fails
  EzValidator<T> maxDate(DateTime date, [String? message]) =>
      addValidation((v, [_]) {
        DateTime? parsed;
        if (v is DateTime) {
          parsed = v;
        } else {
          parsed = DateTime.tryParse(v.toString());
          if (parsed == null) {
            return (
              FieldError(message ?? EzValidator.globalLocale.date('$v', label)),
              v
            );
          }
        }

        return parsed.isBefore(date) || parsed.isAtSameMomentAs(date)
            ? (null, parsed as T)
            : (
                FieldError(message ??
                    EzValidator.globalLocale.dateMax('$v', date, label)),
                v
              );
      });
}
