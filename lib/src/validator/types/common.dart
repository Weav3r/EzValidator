import '../../../ez_validator.dart';
import '../validator_error.dart';

extension CommonValidatorExtensions<T> on EzValidator<T> {
  /// add a validation to check if the value is null or empty
  /// [message] is the message to return if the validation fails
  EzValidator<T> required([String? message]) => addValidation(
        (v, [_]) => v == null || v.isNullOrEmpty
            ? (
                FieldError(message ?? EzValidator.globalLocale.required(label)),
                v
              )
            : (null, v),
      );

  /// add a validation to check if the value is of type [type]
  /// [message] is the message to return if the validation fails
  EzValidator<T> isType(Type type, [String? message]) => addValidation(
        (v, [_]) {
          if (type == Map && v is Map) {
            return (null, v);
          }
          if (v.runtimeType == double || v.runtimeType == int && type == num) {
            return (null, v);
          }
          return v.runtimeType == type
              ? (null, v)
              : (
                  FieldError(message ??
                      EzValidator.globalLocale.isTypeOf(type, label)),
                  v
                );
        },
      );

  /// add a validation to check if the value is less than [minLength]
  /// [message] is the message to return if the validation fails
  EzValidator<T> minLength(int minLength, [String? message]) => addValidation(
        (v, [_]) {
          if (v is String) {
            return v.length < minLength
                ? (
                    FieldError(message ??
                        EzValidator.globalLocale
                            .minLength(v, minLength, label)),
                    v
                  )
                : (null, v);
          }
          if (v is List) {
            return v.length < minLength
                ? (
                    FieldError(message ??
                        EzValidator.globalLocale
                            .minLength(v.toString(), minLength, label)),
                    v
                  )
                : (null, v);
          }
          if (v is Map) {
            return v.length < minLength
                ? (
                    FieldError(message ??
                        EzValidator.globalLocale
                            .minLength(v.toString(), minLength, label)),
                    v
                  )
                : (null, v);
          }
          return (null, v);
        },
      );

  /// add a validation to check if the value is less than [maxLength]
  /// [message] is the message to return if the validation fails
  EzValidator<T> maxLength(int maxLength, [String? message]) =>
      addValidation((v, [_]) {
        if (v is String) {
          return v.length > maxLength
              ? (
                  FieldError(message ??
                      EzValidator.globalLocale.maxLength(v, maxLength, label)),
                  v
                )
              : (null, v);
        }
        if (v is List) {
          return v.length > maxLength
              ? (
                  FieldError(message ??
                      EzValidator.globalLocale
                          .maxLength(v.toString(), maxLength, label)),
                  v
                )
              : (null, v);
        }
        if (v is Map) {
          return v.length > maxLength
              ? (
                  FieldError(message ??
                      EzValidator.globalLocale
                          .maxLength(v.toString(), maxLength, label)),
                  v
                )
              : (null, v);
        }
        return (null, v);
      });

  /// add a custom validation
  EzValidator<T> addMethod(ValidationCallback<T> validWhen) =>
      addValidation((v, [_]) => validWhen(v, _));

  /// adjust the validation based on the value of another field
  ///
  /// [validator] is the validation to run if the condition is met
  EzValidator<T> when(ValidationCallback<T> validator) {
    return addValidation((currentFieldValue, [ref]) {
      return validator(currentFieldValue, ref);
    });
  }

  /// Dynamically adjust field validation based on another field's value.
  ///
  /// [condition] is a function that takes the value of the field specified by [ref] and evaluates it to return a boolean. If `true`, [then] is applied; if `false`, [orElse] is applied.
  ///
  /// [then] specifies the `EzValidator` instance to use for validation when [condition] evaluates to `true`. It defines how the field should be validated if the condition is met.
  ///
  /// [orElse] specifies the `EzValidator` instance to use for validation when [condition] evaluates to `false`. It provides an alternative validation logic for when the condition is not met.
  ///
  EzValidator<T> dependsOn({
    required bool Function(Map<dynamic, dynamic>? ref) condition,
    required EzValidator<T> then,
    EzValidator<T>? orElse,
  }) {
    return addValidation((value, [formData]) {
      if (condition(formData)) {
        for (var validation in then.validations) {
          final (error, transformedValue) = validation(value, formData);
          if (error != null) {
            return (error, transformedValue);
          }
          if (transformedValue != null) {
            value = transformedValue;
          }
        }
      } else if (orElse != null) {
        for (var validation in orElse.validations) {
          final (error, transformedValue) = validation(value, formData);
          if (error != null) {
            return (error, transformedValue);
          }
          if (transformedValue != null) {
            value = transformedValue;
          }
        }
      }
      return (null, value);
    });
  }

  /// Transform the value before running the validation
  /// [transformFunction] is the function to run on the value
  EzValidator<T> transform(T? Function(T?) transformFunction) {
    transforms.add(transformFunction);
    return this;
  }
}

extension OptionalValidation<T> on T? {
  bool get isNullOrEmpty {
    if (this == null) {
      return true;
    }
    if (this is String) {
      return (this as String).isEmpty || (this as String).trim().isEmpty;
    }
    if (this is List) {
      return (this as List).isEmpty;
    }
    if (this is Map) {
      return (this as Map).isEmpty;
    }
    return false;
  }
}
