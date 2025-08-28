import 'package:ez_validator/ez_validator.dart';
import 'package:ez_validator/src/validator/validator_error.dart';
import 'package:test/test.dart';

void main() {
  group('Nested schema validation with noUnknown', () {
    final EzSchema employeeSchema = EzSchema.shape({
      "name": EzValidator<String>().required(),
      "role": EzValidator<String>().required(),
    }, fillSchema: false, noUnknown: true);

    final EzSchema departmentSchema = EzSchema.shape({
      "departmentName": EzValidator<String>().required(),
      "employees": employeeSchema.arrayOf(),
    }, noUnknown: true);

    final EzSchema complexSchema = EzSchema.shape({
      "departments": departmentSchema.arrayOf(),
    }, noUnknown: true);

    test('Department data with unknown fields fails validation', () {
      final departmentDataWithUnknown = {
        "departmentName": "Engineering",
        "employees": [
          {"name": "John Doe", "role": "Developer"},
          {"name": "Jane Smith", "role": "Manager"},
        ],
        "unknownField": "unexpected" // Unknown field that should cause failure
      };

      final (_, errors) =
          departmentSchema.validateSync(departmentDataWithUnknown);
      expect(errors, isNotEmpty,
          reason: 'Unknown field should cause validation error');
      expect(errors.keys, contains('unknownField'),
          reason: 'Unknown field "unknownField" should be detected');
    });

    test(
        'Complex schema data with unknown fields in nested structure fails validation',
        () {
      final complexDataWithUnknown = {
        "departments": [
          {
            "departmentName": "Engineering",
            "employees": [
              {
                "name": "John Doe",
                "role": "Developer",
                "unknownEmployeeField": "unexpected" // Unknown field
              },
              {"name": "Jane Smith", "role": "Manager"},
            ],
            "unknownDepartmentField":
                "unexpected" // Unknown field in department
          },
        ],
        "unknownRootField": "unexpected" // Unknown field at the root level
      };

      final (_, errors) = complexSchema.validateSync(complexDataWithUnknown);
      expect(errors, isNotEmpty);
      final departmentErrors = (errors['departments'] as ArrayError).items![0] as SchemaError;
      expect(departmentErrors.fields!.keys, contains('unknownDepartmentField'));
      final employeeErrors = (departmentErrors.fields!['employees'] as ArrayError).items![0] as SchemaError;
      expect(employeeErrors.fields!.keys, contains('unknownEmployeeField'));
      expect(errors.keys, contains('unknownRootField'));
    });
  });
}