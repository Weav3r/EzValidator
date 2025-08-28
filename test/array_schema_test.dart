import 'package:ez_validator/ez_validator.dart';
import 'package:ez_validator/src/validator/validator_error.dart';
import 'package:test/test.dart';

void main() {
  group('EzArraySchema', () {
    final userSchema = EzSchema.shape({
      'name': EzValidator<String>().required(),
      'email': EzValidator<String>().required().email(),
    });

    test('should validate a list of users', () {
      final validator = userSchema.arrayOf();
      final data = [
        {'name': 'John Doe', 'email': 'john.doe@example.com'},
        {'name': 'Jane Doe', 'email': 'jane.doe@example.com'},
      ];
      final errors = validator.validate(data);
      expect(errors, isNull);
    });

    test('should return errors for invalid data', () {
      final validator = userSchema.arrayOf();
      final data = [
        {'name': 'John Doe', 'email': 'john.doe@example.com'},
        {'name': 'Jane Doe', 'email': 'invalid-email'},
      ];
      final errors = validator.validate(data);
      expect(errors, isNotNull);
      expect(errors, isA<ArrayError>());
      final arrayError = errors as ArrayError;
      expect(arrayError.items!.length, 1);
      expect(arrayError.items![1], isA<SchemaError>());
      final schemaError = arrayError.items![1] as SchemaError;
      expect(schemaError.fields!.containsKey('email'), isTrue);
    });

    test('should enforce minLength', () {
      final validator = userSchema.arrayOf().minLength(2);
      final data = [
        {'name': 'John Doe', 'email': 'john.doe@example.com'},
      ];
      final errors = validator.validate(data);
      expect(errors, isNotNull);
      expect(errors, isA<FieldError>());
    });

    test('should enforce maxLength', () {
      final validator = userSchema.arrayOf().maxLength(1);
      final data = [
        {'name': 'John Doe', 'email': 'john.doe@example.com'},
        {'name': 'Jane Doe', 'email': 'jane.doe@example.com'},
      ];
      final errors = validator.validate(data);
      expect(errors, isNotNull);
      expect(errors, isA<FieldError>());
    });

    test('should enforce uniqueBy', () {
      final validator = userSchema.arrayOf().uniqueBy('email');
      final data = [
        {'name': 'John Doe', 'email': 'john.doe@example.com'},
        {'name': 'Jane Doe', 'email': 'john.doe@example.com'},
      ];
      final errors = validator.validate(data);
      expect(errors, isNotNull);
      expect(errors, isA<FieldError>());
    });
  });
}
