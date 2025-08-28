// ignore_for_file: avoid_shadowing_type_parameters

import 'package:ez_validator/ez_validator.dart';
import 'package:ez_validator/src/validator/validator_error.dart';

extension SchemaValidatorExtensions<T> on EzValidator<T> {
  /// Checks if the value is a valid schema
  /// [message] is the message to return if the validation fails
  EzValidator<T> schema(EzSchema schema, [String? message]) =>
      addValidation((v, [_]) {
        if (v is Map<String, dynamic>) {
          final errors = schema.catchErrors(v);
          return errors.isEmpty ? null : SchemaError(errors);
        }
        return const FieldError('Invalid type for schema validation');
      });
}
