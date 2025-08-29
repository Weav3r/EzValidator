import 'package:ez_validator/ez_validator.dart';
import 'package:test/test.dart';

void main() {
  group('Schema-Level Rules', () {
    test('requireAtLeastOne', () {
      final schema = EzSchema.shape({
        'a': EzValidator<String>(),
        'b': EzValidator<String>(),
      });
      schema.requireAtLeastOne(['a', 'b']);

      var errors = schema.catchErrors({'a': 'hello'});
      expect(errors.isEmpty, isTrue);

      errors = schema.catchErrors({'b': 'world'});
      expect(errors.isEmpty, isTrue);

      errors = schema.catchErrors({});
      expect(errors.containsKey('_schema'), isTrue);
    });

    test('requireExactlyOne', () {
      final schema = EzSchema.shape({
        'a': EzValidator<String>(),
        'b': EzValidator<String>(),
      });
      schema.requireExactlyOne(['a', 'b']);

      var errors = schema.catchErrors({'a': 'hello'});
      expect(errors.isEmpty, isTrue);

      errors = schema.catchErrors({'b': 'world'});
      expect(errors.isEmpty, isTrue);

      errors = schema.catchErrors({'a': 'hello', 'b': 'world'});
      expect(errors.containsKey('_schema'), isTrue);

      errors = schema.catchErrors({});
      expect(errors.containsKey('_schema'), isTrue);
    });

    test('forbidTogether', () {
      final schema = EzSchema.shape({
        'a': EzValidator<String>(),
        'b': EzValidator<String>(),
      });
      schema.forbidTogether(['a', 'b']);

      var errors = schema.catchErrors({'a': 'hello'});
      expect(errors.isEmpty, isTrue);

      errors = schema.catchErrors({'b': 'world'});
      expect(errors.isEmpty, isTrue);

      errors = schema.catchErrors({});
      expect(errors.isEmpty, isTrue);

      errors = schema.catchErrors({'a': 'hello', 'b': 'world'});
      expect(errors.containsKey('_schema'), isTrue);
    });
  });
}
