import 'package:ez_validator/src/validator/ez_validator_builder.dart';

extension ListValidatorExtensions<T> on EzValidator<T> {
  /// Checks if the value is a list of [type]
  /// [message] is the message to return if the validation fails
  EzValidator<T> listOf(Type type, [String? message]) =>
      addValidation((v, [_]) {
        if (v is List) {
          for (var item in v) {
            if (type == Map && item is Map) {
              continue;
            }
            if (item.runtimeType != type) {
              return message ?? EzValidator.globalLocale.listOf(type, label);
            }
          }
          return null;
        }
        return 'Invalid type for list validation';
      });

  /// Checks if the value is one of [items]
  /// [message] is the message to return if the validation fails
  EzValidator<T> oneOf(List<T> items, [String? message]) =>
      addValidation((v, [_]) => items.contains(v)
          ? null
          : message ?? EzValidator.globalLocale.oneOf(items, '$v', label));

  /// Checks if the value is not one of [items]
  /// [message] is the message to return if the validation fails
  EzValidator<T> notOneOf(List<T> items, [String? message]) =>
      addValidation((v, [_]) => !items.contains(v)
          ? null
          : message ?? EzValidator.globalLocale.notOneOf(items, '$v', label));

  /// Define an array of [itemValidator] to validate each item in the array
  // ignore: avoid_shadowing_type_parameters
  EzValidator<List<T>> arrayOf<T>(EzValidator<T> itemValidator) {
    return EzValidator<List<T>>().addValidation((list, [entireData]) {
      if (list == null) {
        return null;
      }
      List<dynamic> errorsList = [];
      for (var i = 0; i < list.length; i++) {
        var item = list[i];
        var error = itemValidator.validate(item, entireData);

        if (error != null) {
          errorsList.add(error);
        }
      }
      if (errorsList.isNotEmpty) {
        return errorsList;
      }
      return null;
    });
  }

  /// Validates a List where each element is validated with [itemValidator].
/// Optionally accepts a [transform] function to preprocess each item,
/// [typeGuard] for custom type validation, and [strict] controls whether to enforce type checking before validation.
/// 
/// - transform: runs first, applied to each element
/// - typeGuard: runs next, after transform, if provided
/// - strict: if true, runs a Dart is! U check after typeGuard (default: true)
EzValidator<List<U>> arrayOfFlexible<U>(
  EzValidator<U> itemValidator, {
  U Function(dynamic raw)? transform,
  bool Function(dynamic item)? typeGuard,
  bool strict = true,
}) {
  return EzValidator<List<U>>().addValidation((value, [entire]) {
    if (value == null) return null;
    // if (value is! List) return 'Expected a list but got ${value.runtimeType}';

    final errors = <int, dynamic>{};

    for (int i = 0; i < value.length; i++) {
      final rawItem = value[i];
      dynamic item;

      // 1. Optional transformation
      try {
        item = transform != null ? transform(rawItem) : rawItem;
      } catch (e) {
        errors[i] = 'Failed to transform element: ${e.runtimeType}: ${e.toString()}';
        continue;
      }

      // 2. Optional custom type guard
      if (typeGuard != null && !typeGuard(item)) {
        errors[i] = 'Element failed custom type guard check: ${item.runtimeType}';
        continue;
      }

      // 3. Optional strict Dart type check
      if (strict && item is! U) {
        errors[i] = 'Expected element of type ${U.toString()}, got ${item.runtimeType}';
        continue;
      }

      // 4. Validate the element
      try {
        final error = itemValidator.validate(item as U, entire);
        if (error != null) {
          errors[i] = error;
        }
      } catch (e) {
        errors[i] = 'Validation threw an exception: ${e.runtimeType}: ${e.toString()}';
      }
    }

    return errors.isEmpty ? null : errors;
  });
}
}
