/// Recursively removes Dart record/tuple `(error, value)` from an error structure,
/// returning only the error portion (null, strings, or nested maps/lists).
///
/// This is useful after calling `validateSync`, when you want to discard all
/// processed values and keep only the error information.
///
/// Example:
/// ```dart
/// final (data, errors) = schema.validateSync(input);
/// final flatErrors = flattenErrorRecords(errors);
/// // flatErrors now contains only error branches, no Dart records (tuples).
/// ```
///
/// - Accepts any error tree (Map, List, Record, null).
/// - Handles nested errors as well.
dynamic flattenErrorRecords(dynamic errorObj) {
  if (errorObj == null) {
    return null;
  } else if (errorObj is List) {
    return errorObj.map(flattenErrorRecords).toList();
  } else if (errorObj is Map) {
    return errorObj.map((k, v) => MapEntry(k, flattenErrorRecords(v)));
  } else if (errorObj is (dynamic, dynamic)) {
    var (err, _) = errorObj;
    return flattenErrorRecords(err);
  } else {
    return errorObj;
  }
}

/// Flattens a nested error structure (containing Maps and Lists) into a flat map
/// with dot notation keys, ideal for use in forms, error summaries, or APIs.
///
/// Use this after `flattenErrorRecords` to obtain a single-level map of all
/// leaf errors keyed by their full path (e.g., `'students.1.name'`).
///
/// Example:
/// ```dart
/// final (data, errors) = schema.validateSync(input);
/// final flatErrors = flattenErrorRecords(errors);
/// final dotErrors = flattenErrors(flatErrors);
/// // dotErrors: { 'students.1.age': 'Students must be at least 18 years old.' }
/// ```
///
/// - Accepts any nested error tree (Map, List, String, null).
/// - Skips null values.
/// - Uses dot notation to indicate the full path to each error.
Map<String, dynamic> flattenErrors(dynamic errors, [String parent = '']) {
  final result = <String, dynamic>{};
  if (errors is Map) {
    errors.forEach((key, value) {
      final fullKey = parent.isEmpty ? '$key' : '$parent.$key';
      result.addAll(flattenErrors(value, fullKey));
    });
  } else if (errors is List) {
    for (var i = 0; i < errors.length; i++) {
      final value = errors[i];
      if (value != null) {
        final fullKey = parent.isEmpty ? '$i' : '$parent.$i';
        result.addAll(flattenErrors(value, fullKey));
      }
    }
  } else if (errors != null) {
    if (parent.isNotEmpty) {
      result[parent] = errors;
    }
  }
  return result;
}