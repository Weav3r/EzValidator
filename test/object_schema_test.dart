import 'package:ez_validator/ez_validator.dart';
import 'package:test/test.dart';

void main() {
  group('Object Schema Validation', () {
    final EzSchema singleStudentSchema = EzSchema.shape({
      "name": EzValidator<String>().required(),
      "age": EzValidator<int>().min(18),
    });

    final EzSchema studentsSchema = EzSchema.shape({
      "students": singleStudentSchema.arrayOf().required(),
    });

    test('Check Simple schema Object', () {
      expect(
        singleStudentSchema.catchErrors({
          "name": "John Doe",
          "age": 18,
        }),
        isEmpty,
        reason: 'valid value',
      );
      expect(
        singleStudentSchema.catchErrors({
          "name": "John Doe",
          "age": 17,
        }),
        isNotEmpty,
        reason: 'Invalid value',
      );
    });

    test('Check Studnets schema list', () {
      final (_, errors) = studentsSchema.validateSync({
        'students': [
          {"name": "John Doe", "age": 18},
          {"name": "Jane Smith", "age": 17},
        ],
      });
      expect(errors, isNotEmpty, reason: 'Students data should be invalid');
    });
  });
}