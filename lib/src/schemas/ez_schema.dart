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

  Map<String, SchemaValue> get schema => _schema;
  SchemaValue operator [](String key) => _schema[key]!;

  /// Validates the provided data and returns a map of errors.
  Map<dynamic, dynamic> catchErrors(Map<dynamic, dynamic> form) {
    _processedData = _fillSchemaIfNeeded(form);
    return _internalValidateData();
  }

  /// Internal core validation logic that operates on _processedData.
  Map<dynamic, dynamic> _internalValidateData() {
    Map<dynamic, dynamic> errors = {};

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

        // Corrected: Use 'return;' instead of 'continue;' for forEach loops.
        // Skip this nested schema completely if not present and not filling.
        if (!(fillSchema ?? false) && !_processedData.keys.contains(key)) {
          return; // Skip to the next item in the forEach loop
        }

        if (nestedInputData == null ||
            nestedInputData is! Map<dynamic, dynamic>) {
          nestedInputData = {};
        } else {
          nestedInputData = Map<dynamic, dynamic>.from(nestedInputData);
        }

        var nestedErrors = value.catchErrors(nestedInputData);
        if (nestedErrors.isNotEmpty) {
          errors[key] = nestedErrors;
        }

        if (_processedData.keys.contains(key) || (fillSchema ?? false)) {
          _processedData[key] = value._processedData;
        }
      }
    });

    if (noUnknown) {
      for (var key in _processedData.keys) {
        if (!_schema.containsKey(key)) {
          errors[key] = EzValidator.globalLocale.unknownFieldMessage;
        }
      }
    }
    return errors;
  }

  /// Validates the provided data and returns a tuple of transformed data and errors.
  (Map<dynamic, dynamic> data, Map<dynamic, dynamic> errors) validateSync(
    Map<dynamic, dynamic> form,
  ) {
    _processedData = _fillSchemaIfNeeded(form);
    final errors = _internalValidateData();
    return (_processedData, errors);
  }

  (Map<dynamic, dynamic> data, Map<dynamic, dynamic> errors) validateSyncFlat(
      Map<dynamic, dynamic> form) {
    final (data, errors) = validateSync(form);
    return (data, flattenErrorRecords(errors));
  }

  (Map<dynamic, dynamic> data, Map<dynamic, dynamic> errors)
      validateSyncFlatDotErrors(Map<dynamic, dynamic> form) {
    final (data, errors) = validateSyncFlat(form);
    return (data, flattenErrors(errors));
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
}
