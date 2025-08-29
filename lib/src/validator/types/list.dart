import 'package:ez_validator/src/validator/ez_validator_builder.dart';
import 'package:ez_validator/src/validator/validator_error.dart';

extension ListValidatorExtensions<T> on EzValidator<T> {
  /// Checks if the value is a list of [type]
  /// [message] is the message to return if the validation fails
  EzValidator<T> listOf(Type type, [String? message]) =>
      addValidation((v, [_]) {
        if (v is! List) {
          return (const FieldError('Invalid type for list validation'), v);
        }

        for (var item in v) {
          if (type == Map && item is Map) {
            continue;
          }
          if (item.runtimeType != type) {
            return (
              FieldError(
                  message ?? EzValidator.globalLocale.listOf(type, label)),
              v
            );
          }
        }
        return (null, v);
      });

  /// Checks if the value is one of [items]
  /// [message] is the message to return if the validation fails
  EzValidator<T> oneOf(List<T> items, [String? message]) =>
      addValidation((v, [_]) => items.contains(v)
          ? (null, v)
          : (
              FieldError(message ??
                  EzValidator.globalLocale.oneOf(items, '$v', label)),
              v
            ));

  /// Checks if the value is not one of [items]
  /// [message] is the message to return if the validation fails
  EzValidator<T> notOneOf(List<T> items, [String? message]) =>
      addValidation((v, [_]) => !items.contains(v)
          ? (null, v)
          : (
              FieldError(message ??
                  EzValidator.globalLocale.notOneOf(items, '$v', label)),
              v
            ));

  @Deprecated('Use EzSchema.arrayOf() instead')
  static EzValidator<List<R>> arrayOf<R>(EzValidator<R> itemValidator) {
    return EzValidator<List<R>>()
      ..addValidation((dynamic rawList, [Map<dynamic, dynamic>? ref]) {
        if (rawList == null) return (null, null);
        if (rawList is! List) {
          return (const FieldError('Expected a List'), rawList);
        }

        final List<R> processedList = [];
        final Map<int, ValidationError> errors = {};

        for (var i = 0; i < rawList.length; i++) {
          final (error, processedItem) = itemValidator.build()(rawList[i], ref);
          if (error != null) {
            errors[i] = error;
          }
          if (processedItem != null) {
            processedList.add(processedItem);
          }
        }

        return errors.isEmpty
            ? (null, processedList)
            : (ArrayError(errors), rawList as List<R>);
      });
  }

  /// Validates a List where each element is validated with [itemValidator].
  /// Optionally accepts a [transform] function to preprocess each item,
  /// [typeGuard] for custom type validation, and [strict] controls whether to enforce type checking before validation.
  ///
  /// - transform: runs first, applied to each element
  /// - typeGuard: runs next, after transform, if provided
  /// - strict: if true, runs a Dart is! U check after typeGuard (default: true)
  @Deprecated('Use EzSchema.arrayOf() instead')
  EzValidator<List<U>> arrayOfFlexible<U>(
    EzValidator<U> itemValidator, {
    U Function(dynamic raw)? transform,
    bool Function(dynamic item)? typeGuard,
    bool strict = true,
  }) {
    var validator = EzValidator<List<U>>();
    validator.addValidation((rawValue, [entire]) {
      if (rawValue == null) return (null, null);

      final errors = <int, ValidationError>{};
      final processedList = <U>[];

      final value = rawValue as List;

      for (int i = 0; i < value.length; i++) {
        final rawItem = value[i];
        dynamic item;

        // 1. Optional transformation
        try {
          item = transform != null ? transform(rawItem) : rawItem;
        } catch (e) {
          errors[i] = FieldError(
              'Failed to transform element: ${e.runtimeType}: ${e.toString()}');
          continue;
        }

        // 2. Optional custom type guard
        if (typeGuard != null && !typeGuard(item)) {
          errors[i] = FieldError(
              'Element failed custom type guard check: ${item.runtimeType}');
          continue;
        }

        // 3. Optional strict Dart type check
        if (strict && item is! U) {
          errors[i] = FieldError(
              'Expected element of type ${U.toString()}, got ${item.runtimeType}');
          continue;
        }

        // 4. Validate the element
        try {
          final (error, processedItem) =
              itemValidator.build()(item as U, entire);
          if (error != null) {
            errors[i] = error;
          }
          if (processedItem != null) {
            processedList.add(processedItem);
          }
        } catch (e) {
          errors[i] = FieldError(
              'Validation threw an exception: ${e.runtimeType}: ${e.toString()}');
        }
      }

      return errors.isEmpty
          ? (null, processedList)
          : (ArrayError(errors), processedList);
    });
    return validator;
  }
}
