import 'package:ez_validator/ez_validator.dart';
import 'package:ez_validator/src/validator/validator_error.dart';
import 'package:test/test.dart';

void main() {
  group('Mixt Validation', () {
    final checkDashValidator = EzValidator<String>()
        .addMethod((v) => v!.contains('-') ? null : const FieldError('Invalid String'))
        .build();
    final checkResultValidator =
        EzValidator<num>().addMethod((v) => v! + 10 == 15 ? null : const FieldError('Invalid Number')).build();
    final checkDateValidator =
        EzValidator<DateTime>().addMethod((v) => v!.year == 2021 ? null : const FieldError('Invalid Date')).build();
    final checkListValidator =
        EzValidator<List<int>>().addMethod((v) => v![1] == 5 ? null : const FieldError('Invalid List')).build();
    final checkMapValidator =
        EzValidator<Map<String, int>>().addMethod((v) => v!['a'] == 5 ? null : const FieldError('Invalid Map')).build();
    final checkJson = EzValidator<Map<String, dynamic>>()
        .addMethod((v) => v?['foo'] == 'bar' ? null : const FieldError('Invalid foo'))
        .addMethod((v) => v?['bar'] == "Flutter" ? null : const FieldError('Invalid bar'))
        .addMethod((v) => v?['items'][0] == 'a' ? null : const FieldError('Invalid items'))
        .build();

    test('checkDashValidator', () {
      expect(checkDashValidator('2021-10-10'), isNull, reason: 'valid value');
      expect(checkDashValidator('20211010'), isNotNull,
          reason: 'Invalid value');
    });

    test('checkResultValidator', () {
      expect(checkResultValidator(5), isNull, reason: 'valid value');
      expect(checkResultValidator(4), isNotNull, reason: 'Invalid value');
    });

    test('checkDateValidator', () {
      expect(checkDateValidator(DateTime(2021)), isNull, reason: 'valid value');
      expect(checkDateValidator(DateTime(2020)), isNotNull,
          reason: 'Invalid value');
    });

    test('checkListValidator', () {
      expect(checkListValidator([1, 5, 3]), isNull, reason: 'valid value');
      expect(checkListValidator([1, 2, 3]), isNotNull, reason: 'Invalid value');
    });

    test('checkMapValidator', () {
      expect(
        checkMapValidator({'a': 5, 'b': 2}),
        isNull,
        reason: 'valid value',
      );
      expect(
        checkMapValidator({'a': 2, 'b': 2}),
        isNotNull,
        reason: 'Invalid value',
      );
    });

    test('checkMixValidator', () {
      expect(
        checkJson({
          'foo': 'bar',
          'bar': 'Flutter',
          'items': ["a", "b", "c"]
        }),
        isNull,
        reason: 'valid JSON',
      );
      expect(
        checkJson({
          'foo': 'bar',
          'bar': 'Dart',
          'items': ["a", "b", "c"]
        }),
        isNotNull,
        reason: 'Invalid JSON',
      );
    });
  });
}