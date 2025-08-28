import 'package:ez_validator/ez_validator.dart';
import 'package:ez_validator/src/validator/validator_error.dart';

class EzArraySchema<T> extends EzValidator<List<T>> {
  EzArraySchema() : super(optional: false);

  EzValidator<List<T>> minLength(int minLength, [String? message]) {
    return addValidation((v, [_]) {
      if (v!.length < minLength) {
        return FieldError(message ??
            EzValidator.globalLocale.minLength(v.toString(), minLength, label));
      }
      return null;
    });
  }

  EzValidator<List<T>> maxLength(int maxLength, [String? message]) {
    return addValidation((v, [_]) {
      if (v!.length > maxLength) {
        return FieldError(message ??
            EzValidator.globalLocale.maxLength(v.toString(), maxLength, label));
      }
      return null;
    });
  }

  EzValidator<List<T>> uniqueBy(String field, [String? message]) {
    return addValidation((v, [_]) {
      if (v == null) return null;
      final uniqueValues = <dynamic>{};
      for (final item in v) {
        if (item is Map) {
          final value = item[field];
          if (uniqueValues.contains(value)) {
            return FieldError(message ?? 'Values are not unique for field "$field"');
          }
          uniqueValues.add(value);
        }
      }
      return null;
    });
  }
}
