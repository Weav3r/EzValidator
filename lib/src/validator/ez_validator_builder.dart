import 'package:ez_validator/src/validator/types/validators.dart';
import 'package:ez_validator/src/validator/ez_locale.dart';
import 'package:ez_validator/src/validator/validator_error.dart';

import '../common/schema_value.dart';
import 'ez_validator_locale.dart';

typedef ValidationCallback<T> = (ValidationError?, T?) Function(T? value,
    [Map<dynamic, dynamic>? ref]);

class EzValidator<T> extends SchemaValue {
  EzValidator({this.optional = false, this.defaultValue, this.label});

  final bool optional;
  final T? defaultValue;
  final String? label;

  /// Chainable, null-aware transforms
  final List<T? Function(T?)> transforms = [];

  /// Allow coercion from raw JSON input
  T Function(dynamic)? _rawCaster;

  EzValidator<T> fromRaw(T Function(dynamic raw) castFn) {
    _rawCaster = castFn;
    return this;
  }

  /// Add a transform (null-safe)
  EzValidator<T> transform(T? Function(T?) fn) {
    transforms.add(fn);
    return this;
  }

  final List<ValidationCallback<T>> validations = [];
  static EzLocale globalLocale = const DefaultLocale();

  EzValidator<T> addValidation(ValidationCallback<T> validator) {
    validations.add(validator);
    return this;
  }

  static void setLocale(EzLocale locale) {
    globalLocale = locale;
  }

  ValidationError? validate(dynamic rawValue,
          [Map<dynamic, dynamic>? entireData]) =>
      _test(rawValue, entireData).$1;

  (ValidationError?, T?) _test(dynamic rawValue, [Map<dynamic, dynamic>? ref]) {
    T? value;
    try {
      // 1. Cast
      if (_rawCaster != null) {
        value = _rawCaster!(rawValue);
      } else {
        value = rawValue as T?;
      }

      // 2. Apply transforms (all are null-aware)
      for (final t in transforms) {
        value = t(value);
        print('Transform applied, new value: $value');
      }

      // 3. Run validations
      for (var validate in validations) {
        if (optional && value.isNullOrEmpty) {
          return (null, value); // optional skips validation
        }
        final (error, transformedValue) = validate(value, ref);
        if (error != null) {
          return (
            error,
            transformedValue
          ); // Return both error and last transformed value
        }
        // Update value with any transformations from the validator
        if (transformedValue != null) {
          value = transformedValue;
        }
      }

      return (null, value);
    } catch (e) {
      return (FieldError(e.toString()), value);
    }
  }

  (ValidationError?, T?) Function(dynamic, [Map<dynamic, dynamic>?]) build() =>
      _test;
}
