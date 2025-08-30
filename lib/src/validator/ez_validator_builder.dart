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

  /// Per-validator debug configuration
  bool _debugEnabled = false;
  void Function(String message)? _debugPrinter;

  /// Enable debug mode for this specific validator
  EzValidator<T> enableDebug({bool enabled = true, void Function(String)? printer}) {
    _debugEnabled = enabled;
    _debugPrinter = printer;
    return this;
  }

  /// Internal debug logging method, called by this validator
  void _debug(String msg) {
    if (_debugEnabled || debugEnabled) {
      (_debugPrinter ?? debugPrinter ?? print)(msg);
    }
  }

  /// Global debug configuration
  static bool debugEnabled = false;
  static void Function(String message)? debugPrinter;

  /// Enable global debug mode for all validators
  static void enableGlobalDebug({bool enabled = true, void Function(String)? printer}) {
    debugEnabled = enabled;
    debugPrinter = printer;
  }

  final List<T? Function(T?)> transforms = [];
  final List<ValidationCallback<T>> validations = [];
  static EzLocale globalLocale = const DefaultLocale();

  T? Function(dynamic)? _fromRaw;

  /// Generic raw parser
  EzValidator<T> fromRaw<R>(T? Function(R raw) parser) {
    _fromRaw = (dynamic raw) {
      if (raw is R) return parser(raw);
      return raw as T?;
    };
    return this;
  }

  T? _coerce(dynamic rawValue) {
    if (_fromRaw != null) return _fromRaw!(rawValue);
    return rawValue as T?;
  }

  EzValidator<T> transform(T? Function(T?) fn) {
    transforms.add(fn);
    return this;
  }

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
      // 1. Cast (with coercion)
      value = _coerce(rawValue);
      _debug("▶ [validate] Initial value after coercion: $value");

      // 2. Apply transforms
      for (final t in transforms) {
        final before = value;
        value = t(value);
        _debug("▶ [validate] Transform result: $before → $value");
      }

      // 3. Run validations
      for (var validate in validations) {
        if (optional && value.isNullOrEmpty) {
          _debug("✅ [validate] Optional empty value allowed");
          return (null, value);
        }
        final (error, transformedValue) = validate(value, ref);
        if (error != null) {
          _debug("❌ [validate] Validation failed: $error");
          return (error, transformedValue);
        }
        if (transformedValue != null) {
          value = transformedValue;
          _debug("▶ [validate] Value updated by validation: $value");
        }
      }

      _debug("✅ [validate] Validation successful, final value: $value");
      return (null, value);
    } catch (e) {
      _debug("❌ [validate] Exception during validation: $e");
      return (FieldError(e.toString()), value);
    }
  }

  (ValidationError?, T?) Function(dynamic, [Map<dynamic, dynamic>?]) build() =>
      _test;
}
