import 'package:ez_validator/src/validator/ez_validator_builder.dart';
import 'package:ez_validator/src/validator/validator_error.dart';

/// A class to hold multiple validators that form a union
///
/// This class is used to validate a value against multiple validators.
class UnionValidator extends EzValidator<dynamic> {
  final List<EzValidator> validators;

  UnionValidator(this.validators) : super() {
    assert(
      validators.isNotEmpty,
      'Union validator must have at least one validator',
    );
    addValidation(_unionValidation);
  }

  (ValidationError?, dynamic) _unionValidation(dynamic value,
      [Map<dynamic, dynamic>? ref]) {
    List<ValidationError> errors = [];
    dynamic transformedValue = value;

    // Try each validator
    for (var validator in validators) {
      try {
        final (error, processedValue) = validator.build()(value, ref);
        if (error == null) {
          // Return the successfully transformed value
          return (null, processedValue ?? value);
        }
        errors.add(error);
        // Keep track of any transformations
        if (processedValue != null) {
          transformedValue = processedValue;
        }
      } catch (e) {
        errors.add(FieldError(e.toString()));
      }
    }
    return (
      FieldError(errors.map((e) => e.message).join(", ")),
      transformedValue
    );
  }
}

/// Extension to add the union method to EzValidator
///
/// method for composing "OR" types.
extension UnionValidatorExtension on EzValidator {
  EzValidator<dynamic> union(List<EzValidator> validators) {
    return UnionValidator(validators);
  }
}
