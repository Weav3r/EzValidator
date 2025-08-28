import 'package:ez_validator/src/common/map_utils.dart';
import 'package:ez_validator/src/schemas/ez_array_schema.dart';
import 'package:ez_validator/src/validator/validator_error.dart';

import '../common/error_utils.dart';
import '../common/schema_value.dart';
import '../validator/ez_validator_builder.dart';

//ez_schema.dart
class EzSchema extends SchemaValue {
  EzSchema.shape(
    this._schema, {
    this.fillSchema = true,
    this.noUnknown = false,
  });

  Map<dynamic, dynamic> _processedData = {};

  final Map<String, SchemaValue> _schema;
  final bool? fillSchema;
  final bool noUnknown;

  final List<String? Function(Map<String, dynamic> data)> _rules = [];

  void addRule(String? Function(Map<String, dynamic> data) rule) {
    _rules.add(rule);
  }

  Map<String, SchemaValue> get schema => _schema;
  SchemaValue operator [](String key) => _schema[key]!;

  /// Validates the provided data and returns a map of errors.
  Map<String, ValidationError> catchErrors(Map<dynamic, dynamic> form) {
    _processedData = _fillSchemaIfNeeded(form);
    return _internalValidateData();
  }

  /// Internal core validation logic that operates on _processedData.
  Map<String, ValidationError> _internalValidateData() {
    Map<String, ValidationError> errors = {};

    _schema.forEach((key, value) {
      if (value is EzValidator) {
        var (error, processedValue) = value.build()(
          _processedData[key],
          _processedData,
        );

        if (error != null) {
          errors[key] = error;
        } else {
          if (_processedData.keys.contains(key)) {
            _processedData[key] = processedValue;
          }
        }
      } else if (value is EzSchema) {
        Map<dynamic, dynamic>? nestedInputData = _processedData[key];

        if (!(fillSchema ?? false) && !_processedData.keys.contains(key)) {
          return;
        }

        if (nestedInputData == null ||
            nestedInputData is! Map<dynamic, dynamic>) {
          nestedInputData = {};
        } else {
          nestedInputData = Map<dynamic, dynamic>.from(nestedInputData);
        }

        var nestedErrors = value.catchErrors(nestedInputData);
        if (nestedErrors.isNotEmpty) {
          errors[key] = SchemaError(nestedErrors);
        }

        if (_processedData.keys.contains(key) || (fillSchema ?? false)) {
          _processedData[key] = value._processedData;
        }
      }
    });

    if (noUnknown) {
      for (var key in _processedData.keys) {
        if (!_schema.containsKey(key)) {
          errors[key] =
              FieldError(EzValidator.globalLocale.unknownFieldMessage);
        }
      }
    }

    for (final rule in _rules) {
      final error = rule(_processedData.cast());
      if (error != null) {
        errors['_schema'] = FieldError(error);
      }
    }

    return errors;
  }

  /// Validates the provided data and returns a tuple of transformed data and errors.
  (Map<String, dynamic> data, Map<String, ValidationError> errors) validateSync(
      Map<dynamic, dynamic> form,
      {bool remap = true}) {
    _processedData = _fillSchemaIfNeeded(form);
    final errors = _internalValidateData();
    final remappedData =
        Map<String, dynamic>.from(mapToStringKeyed(_processedData));
    return (remappedData, errors);
  }

  (Map<String, dynamic> data, Map<String, dynamic> errors) validateSyncFlat(
      Map<dynamic, dynamic> form) {
    final (data, errors) = validateSync(form, remap: false);
    return (data, flattenErrors(errors));
  }

  (Map<String, dynamic> data, Map<String, dynamic> errors)
      validateAndFlattenErrors(Map<dynamic, dynamic> form) {
    final (data, errors) = validateSyncFlat(form);
    return (data, errors);
  }

  Map<dynamic, dynamic> _fillSchemaIfNeeded(Map<dynamic, dynamic> form) {
    final data = Map<dynamic, dynamic>.from(form);
    if (fillSchema ?? false) {
      _schema.forEach((key, value) {
        if (value is EzValidator) {
          data[key] ??= value.defaultValue;
        } else if (value is EzSchema) {
          if (!form.containsKey(key) || form[key] is! Map<dynamic, dynamic>) {
            data[key] = value._populateDefaultValues();
          } else {
            data[key] = value._fillSchemaIfNeeded(
              form[key] as Map<dynamic, dynamic>,
            );
          }
        }
      });
    }
    return data;
  }

  EzArraySchema<Map<String, dynamic>> arrayOf() {
    return EzArraySchema<Map<String, dynamic>>()
      ..addValidation((v, [_]) {
        if (v is List<Map<String, dynamic>>) {
          final errors = <int, ValidationError>{};
          for (var i = 0; i < v.length; i++) {
            final item = v[i];
            final error = catchErrors(item);
            if (error.isNotEmpty) {
              errors[i] = SchemaError(error);
            }
          }
          return errors.isEmpty ? null : ArrayError(errors);
        }
        return const FieldError('Invalid type for arrayOf schema validation');
      });
  }

  Map<String, dynamic> _populateDefaultValues() {
    Map<String, dynamic> defaults = {};
    _schema.forEach((key, value) {
      if (value is EzValidator) {
        defaults[key] = value.defaultValue;
      } else if (value is EzSchema) {
        defaults[key] = value._populateDefaultValues();
      }
    });
    return defaults;
  }

  static String? requireAtLeastOne(List<String> keys, Map<String, dynamic> data,
      {String? message}) {
    for (final key in keys) {
      if (data.containsKey(key) && data[key] != null) {
        return null;
      }
    }
    return message ??
        'At least one of the following fields is required: ${keys.join(', ')}';
  }

  static String? requireExactlyOne(List<String> keys, Map<String, dynamic> data,
      {String? message}) {
    int count = 0;
    for (final key in keys) {
      if (data.containsKey(key) && data[key] != null) {
        count++;
      }
    }
    if (count == 1) {
      return null;
    }
    return message ??
        'Exactly one of the following fields is required: ${keys.join(', ')}';
  }

  static String? forbidTogether(List<String> keys, Map<String, dynamic> data,
      {String? message}) {
    int count = 0;
    for (final key in keys) {
      if (data.containsKey(key) && data[key] != null) {
        count++;
      }
    }
    if (count <= 1) {
      return null;
    }
    return message ??
        'The following fields cannot be present together: ${keys.join(', ')}';
  }
}
