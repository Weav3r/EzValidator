import 'package:ez_validator/src/validator/ez_validator_builder.dart';
import 'package:ez_validator/src/validator/validator_error.dart';

import '../regex_list.dart';

extension StringValidatorExtensions<T> on EzValidator<T> {
  /// match the value with [reg]
  /// [message] is the message to return if the validation fails
  EzValidator<T> matches(RegExp reg, [String? message]) =>
      addValidation((v, [_]) {
        if (v is String) {
          return reg.hasMatch(v)
              ? (null, v)
              : (
                  FieldError(message ??
                      EzValidator.globalLocale.matches(reg.pattern, v, label)),
                  v
                );
        }
        return (const FieldError('Invalid type for pattern matching'), v);
      });

  /// Checks if the value is an email address
  /// [message] is the message to return if the validation fails
  EzValidator<T> email([String? message]) => addValidation((v, [_]) {
        if (v is String) {
          final normalized = v.toLowerCase().trim();
          return emailRegExp.hasMatch(normalized)
              ? (null, normalized as T)
              : (
                  FieldError(
                      message ?? EzValidator.globalLocale.email(v, label)),
                  v
                );
        }
        return (const FieldError('Invalid type for email validation'), v);
      });

  /// Checks if the value is a phone number
  /// [message] is the message to return if the validation fails
  EzValidator<T> phone([String? message]) => addValidation((v, [_]) {
        if (v is String) {
          final normalized = v.replaceAll(RegExp(r'[\s-]'), '');
          return phoneRegExp.hasMatch(normalized)
              ? (null, normalized as T)
              : (
                  FieldError(message ??
                      EzValidator.globalLocale.phoneNumber(v, label)),
                  v
                );
        }
        return (const FieldError('Invalid type for phone validation'), v);
      });

  /// Checks if the value is an ipv4
  /// [message] is the message to return if the validation fails
  EzValidator<T> ip([String? message]) => addValidation((v, [_]) {
        if (v is String) {
          final normalized = v.trim();
          return ipv4RegExp.hasMatch(normalized)
              ? (null, normalized as T)
              : (
                  FieldError(message ?? EzValidator.globalLocale.ip(v, label)),
                  v
                );
        }
        return (const FieldError('Invalid type for ip validation'), v);
      });

  /// Checks if the value is an ipv6
  /// [message] is the message to return if the validation fails
  EzValidator<T> ipv6([String? message]) => addValidation((v, [_]) {
        if (v is String) {
          final normalized = v.trim();
          return ipv6RegExp.hasMatch(normalized)
              ? (null, normalized as T)
              : (
                  FieldError(
                      message ?? EzValidator.globalLocale.ipv6(v, label)),
                  v
                );
        }
        return (const FieldError('Invalid type for ipv6 validation'), v);
      });

  /// Checks if the value is a url
  /// [message] is the message to return if the validation fails
  EzValidator<T> url([String? message]) => addValidation((v, [_]) {
        if (v is String) {
          final normalized = v.trim();
          return urlRegExp.hasMatch(normalized)
              ? (null, normalized as T)
              : (
                  FieldError(message ?? EzValidator.globalLocale.url(v, label)),
                  v
                );
        }
        return (const FieldError('Invalid type for url validation'), v);
      });

  /// Checks if the value is a uuid
  /// [message] is the message to return if the validation fails
  EzValidator<T> uuid([String? message]) => addValidation((v, [_]) {
        if (v is String) {
          final normalized = v.trim();
          return uuidRegExp.hasMatch(normalized)
              ? (null, normalized as T)
              : (
                  FieldError(
                      message ?? EzValidator.globalLocale.uuid(v, label)),
                  v
                );
        }
        return (const FieldError('Invalid type for uuid validation'), v);
      });

  /// Checks if the string is lowercase
  /// [message] is the message to return if the validation fails
  EzValidator<T> lowerCase([String? message]) => addValidation((v, [_]) {
        if (v is String) {
          final normalized = v.trim();
          return normalized == normalized.toLowerCase()
              ? (null, normalized as T)
              : (FieldError(message ?? 'Value must be lowercase'), v);
        }
        return (const FieldError('Invalid type for lowerCase validation'), v);
      });

  /// Checks if the string is uppercase
  /// [message] is the message to return if the validation fails
  EzValidator<T> upperCase([String? message]) => addValidation((v, [_]) {
        if (v is String) {
          final normalized = v.trim();
          return normalized == normalized.toUpperCase()
              ? (null, normalized as T)
              : (FieldError(message ?? 'Value must be uppercase'), v);
        }
        return (const FieldError('Invalid type for lowerCase validation'), v);
      });
}
