import 'package:ez_validator/ez_validator.dart';
import 'package:test/test.dart';

void main() {
  group('Type of Validation', () {
    final isTypeOfString = EzValidator().isType(String).build();
    final isTypeOfList = EzValidator().isType(List<int>).build();
    final isTypeOfMap = EzValidator().isType(Map).build();
    final isTypeOfInt = EzValidator().isType(int).build();
    final isTypeOfDouble = EzValidator().isType(double).build();
    final isTypeOfNum = EzValidator().isType(num).build();
    final isTypeOfDateTime = EzValidator().isType(DateTime).build();
    final isTypeOfBool = EzValidator().isType(bool).build();
    final isTypeOfNull = EzValidator().isType(Null).build();
    final isTypeOfObject = EzValidator().isType(Object).build();
    final isTypeOfListInt = EzValidator().isType(List<int>).build();
    test('IsTypeOfValidator', () {
      expect(isTypeOfString('Flutter').$1, isNull, reason: 'valid value');
      expect(isTypeOfString(5).$1, isNotNull, reason: 'Invalid value');

      expect(isTypeOfList([1, 2, 3]).$1, isNull, reason: 'valid value');
      expect(isTypeOfList('Flutter').$1, isNotNull, reason: 'Invalid value');

      expect(isTypeOfMap({'a': 5, 'b': 2}).$1, isNull, reason: 'valid value');
      expect(isTypeOfMap('Flutter').$1, isNotNull, reason: 'Invalid value');

      expect(isTypeOfInt(5).$1, isNull, reason: 'valid value');
      expect(isTypeOfInt('Flutter').$1, isNotNull, reason: 'Invalid value');

      expect(isTypeOfDouble(5.5).$1, isNull, reason: 'valid value');
      expect(isTypeOfDouble('Flutter').$1, isNotNull, reason: 'Invalid value');

      expect(isTypeOfNum(5).$1, isNull, reason: 'valid value');
      expect(isTypeOfNum('Flutter').$1, isNotNull, reason: 'Invalid value');

      expect(isTypeOfDateTime(DateTime(2021)).$1, isNull, reason: 'valid value');
      expect(isTypeOfDateTime('Flutter').$1, isNotNull, reason: 'Invalid value');

      expect(isTypeOfBool(true).$1, isNull, reason: 'valid value');
      expect(isTypeOfBool('Flutter').$1, isNotNull, reason: 'Invalid value');

      expect(isTypeOfNull(null).$1, isNull, reason: 'valid value');
      expect(isTypeOfNull('Flutter').$1, isNotNull, reason: 'Invalid value');

      expect(isTypeOfObject(Object()).$1, isNull, reason: 'valid value');
      expect(isTypeOfObject('Flutter').$1, isNotNull, reason: 'Invalid value');

      expect(isTypeOfListInt([1, 2, 3]).$1, isNull, reason: 'valid value');
      expect(isTypeOfListInt([1, 2, 'Flutter']).$1, isNotNull,
          reason: 'Invalid value');
    });
  });
}