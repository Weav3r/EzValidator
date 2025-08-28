import 'package:ez_validator/src/validator/ez_validator_builder.dart';
import 'package:ez_validator/src/validator/validator_error.dart';

extension BooleanValidatorExtensions<T> on EzValidator<T> {
  /// Checks if the value is a boolean
  EzValidator<T> boolean([String? message]) => addValidation((v, [_]) {
        return v is bool
            ? null
            : FieldError(message ?? EzValidator.globalLocale.boolean('$v', label));
      });
}
