import 'package:ez_validator/src/validator/types/validators.dart';
import 'package:ez_validator/src/validator/ez_locale.dart';
import 'package:ez_validator/src/validator/validator_error.dart';

import '../common/schema_value.dart';
import 'ez_validator_locale.dart';

typedef ValidationCallback<T> = ValidationError? Function(T? value,
    [Map<dynamic, dynamic>? ref]);

class EzValidator<T> extends SchemaValue {
  EzValidator({this.optional = false, this.defaultValue, this.label});

  /// optional by default is `False`
  /// if optional `True` the required validation will be ignored
  final bool optional;

  /// default is used when casting produces a `null` output value
  final T? defaultValue;

  /// Overrides the key name which is used in error messages.
  final String? label;

  /// transformation function
  /// this function will be called before any validation
  /// it can be used to transform the value before validation
  /// for example: `trim` a string
  /// or `parse` a string to a `DateTime`
  /// or `cast` a `String` to `int` ....
  T Function(T)? transformationFunction;

  /// (NEW) raw caster function to allow coercion from raw JSON input
  T Function(dynamic)? _rawCaster;

  EzValidator<T> fromRaw(T Function(dynamic raw) castFn) {
    _rawCaster = castFn;
    return this;
  }

  final List<ValidationCallback<T>> validations = [];
  static EzLocale globalLocale = const DefaultLocale();

  EzValidator<T> addValidation(ValidationCallback<T> validator) {
    validations.add(validator);
    return this;
  }

  /// set custom locale
  static void setLocale(EzLocale locale) {
    globalLocale = locale;
  }

  /// Global validators
  ValidationError? validate(dynamic rawValue, [Map<dynamic, dynamic>? entireData]) =>
      _test(rawValue, entireData).$1;

  /// Now _test accepts [dynamic] instead of [T?], and applies _rawCaster if present
  (ValidationError?, T?) _test(dynamic rawValue, [Map<dynamic, dynamic>? ref]) {
    T? value;
    try {
      // 1. Cast raw value to T using _rawCaster if present, or plain cast
      if (_rawCaster != null) {
        value = _rawCaster!(rawValue);
      } else {
        value = rawValue as T?;
      }

      // 2. Apply transformation if function exists and value is not null
      if (transformationFunction != null && value != null) {
        value = transformationFunction!(value);
      }

      // 3. Apply validations
      for (var validate in validations) {
        if (optional && value.isNullOrEmpty) {
          // Changed .isNullOrEmpty to == null for bool
          return (null, value); // No error for optional null value
        }
        final result = validate(value, ref);
        if (result != null) {
          return (result, value); // Return error and the value that caused it
        }
      }
      return (null, value); // No error, return the final processed value
    } catch (e) {
//print('Error caught in _test $e\n $st');
      return (
        FieldError(e.toString()),
        value,
      ); // Return error string and the value at point of error
    }
  }

  (ValidationError?, T?) Function(dynamic, [Map<dynamic, dynamic>?]) build() => _test;
}
