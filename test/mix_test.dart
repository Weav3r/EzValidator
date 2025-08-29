import 'package:ez_validator/ez_validator.dart';
import 'package:ez_validator/src/validator/validator_error.dart';
import 'package:test/test.dart';

void main() {
  group('Mixt Validation', () {
    final checkDashValidator = EzValidator<String>()
        .addMethod((v, [_]) => v!.contains('-')
            ? (null, v)
            : (const FieldError('Invalid String'), v))
        .build();
    final checkResultValidator = EzValidator<num>()
        .addMethod((v, [_]) =>
            v! + 10 == 15 ? (null, v) : (const FieldError('Invalid Number'), v))
        .build();
    final checkDateValidator = EzValidator<DateTime>()
        .addMethod((v, [_]) =>
            v!.year == 2021 ? (null, v) : (const FieldError('Invalid Date'), v))
        .build();
    final checkListValidator = EzValidator<List<int>>()
        .addMethod((v, [_]) =>
            v![1] == 5 ? (null, v) : (const FieldError('Invalid List'), v))
        .build();
    final checkMapValidator = EzValidator<Map<String, int>>()
        .addMethod((v, [_]) =>
            v!['a'] == 5 ? (null, v) : (const FieldError('Invalid Map'), v))
        .build();
    final Map<String, dynamic> expected = {
      'foo': 'bar',
      'bar': 'Flutter',
      'items': ['a']
    };
    final checkJson =
        EzValidator<Map<String, dynamic>>().addValidation((v, [_]) {
      if (v == null) return (null, v);
      var result = v;
      if (v['foo'] != expected['foo']) {
        return (const FieldError('Invalid foo'), v);
      }
      if (v['bar'] != expected['bar']) {
        return (const FieldError('Invalid bar'), v);
      }
      if (v['items'][0] != expected['items'][0]) {
        return (const FieldError('Invalid items'), v);
      }
      return (null, result);
    }).build();

    test('checkDashValidator', () {
      var result = checkDashValidator('2021-10-10');
      expect(result.$1, isNull, reason: 'valid value');
      result = checkDashValidator('20211010');
      expect(result.$1, isA<FieldError>(), reason: 'Invalid value');
    });

    test('checkResultValidator', () {
      var result = checkResultValidator(5);
      expect(result.$1, isNull, reason: 'valid value');
      result = checkResultValidator(4);
      expect(result.$1, isA<FieldError>(), reason: 'Invalid value');
    });

    test('checkDateValidator', () {
      var result = checkDateValidator(DateTime(2021));
      expect(result.$1, isNull, reason: 'valid value');
      result = checkDateValidator(DateTime(2020));
      expect(result.$1, isA<FieldError>(), reason: 'Invalid value');
    });

    test('checkListValidator', () {
      var result = checkListValidator([1, 5, 3]);
      expect(result.$1, isNull, reason: 'valid value');
      result = checkListValidator([1, 2, 3]);
      expect(result.$1, isA<FieldError>(), reason: 'Invalid value');
    });

    test('checkMapValidator', () {
      var result = checkMapValidator({'a': 5, 'b': 2});
      expect(result.$1, isNull, reason: 'valid value');
      result = checkMapValidator({'a': 2, 'b': 2});
      expect(result.$1, isA<FieldError>(), reason: 'Invalid value');
    });

    test('checkMixValidator', () {
      var result = checkJson({
        'foo': 'bar',
        'bar': 'Flutter',
        'items': ["a", "b", "c"]
      });
      expect(result.$1, isNull, reason: 'valid JSON');

      result = checkJson({
        'foo': 'bar',
        'bar': 'Dart',
        'items': ["a", "b", "c"]
      });
      expect(result.$1, isA<FieldError>(), reason: 'Invalid JSON');
    });
  });
}
