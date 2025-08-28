import 'package:ez_validator/src/validator/validator_error.dart';

/// Flattens a nested error structure (containing Maps and Lists) into a flat map
/// with dot notation keys, ideal for use in forms, error summaries, or APIs.
///
/// Use this after `validateSync` to obtain a single-level map of all
/// leaf errors keyed by their full path (e.g., `'students.1.name'`).
///
/// Example:
/// ```dart
/// final (data, errors) = schema.validateSync(input);
/// final dotErrors = flattenErrors(errors);
/// // dotErrors: { 'students.1.age': 'Students must be at least 18 years old.' }
/// ```
///
/// - Accepts any nested error tree (Map, List, String, null).
/// - Skips null values.
/// - Uses dot notation to indicate the full path to each error.
Map<String, dynamic> flattenErrors(Map<String, ValidationError> errors, [String parent = '']) {
  final result = <String, dynamic>{};
  errors.forEach((key, value) {
    final fullKey = parent.isEmpty ? key : '$parent.$key';
    if (value is FieldError) {
      result[fullKey] = value.message;
    } else if (value is SchemaError) {
      result.addAll(flattenErrors(value.fields!, fullKey));
    } else if (value is ArrayError) {
      value.items!.forEach((index, error) {
        final arrayKey = '$fullKey.$index';
        if (error is FieldError) {
          result[arrayKey] = error.message;
        } else if (error is SchemaError) {
          result.addAll(flattenErrors(error.fields!, arrayKey));
        } else if (error is ArrayError) {
          // This is a bit of a hack to handle nested arrays
          final nestedErrors = <String, ValidationError>{'': error};
          result.addAll(flattenErrors(nestedErrors, arrayKey));
        }
      });
    }
  });
  return result;
}
