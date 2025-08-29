import 'package:ez_validator/src/validator/ez_validator_builder.dart';
import 'package:ez_validator/src/validator/validator_error.dart';

extension BooleanValidatorExtensions<T> on EzValidator<T> {
  /// Checks if the value is a boolean
  EzValidator<T> boolean([String? message]) => addValidation((v, [_]) {
        final normalized = v is String ? v.toLowerCase().trim() : v;
        if (normalized == 'true') return (null, true as T);
        if (normalized == 'false') return (null, false as T);
        if (normalized is bool) return (null, normalized as T);
        return (
          FieldError(message ?? EzValidator.globalLocale.boolean('$v', label)),
          v
        );
      });
}
