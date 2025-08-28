abstract class ValidationError {
  const ValidationError();

  String? get message;
  Map<String, ValidationError>? get fields;
  Map<int, ValidationError>? get items;

  bool get isLeaf => fields == null && items == null;

  Map<String, dynamic> toJson();
}

class FieldError extends ValidationError {
  const FieldError(this.message);

  @override
  final String? message;

  @override
  Map<String, ValidationError>? get fields => null;

  @override
  Map<int, ValidationError>? get items => null;

  @override
  Map<String, dynamic> toJson() => {'message': message};
}

class SchemaError extends ValidationError {
  const SchemaError(this.fields);

  @override
  final Map<String, ValidationError>? fields;

  @override
  String? get message => null;

  @override
  Map<int, ValidationError>? get items => null;

  @override
  Map<String, dynamic> toJson() =>
      fields!.map((key, value) => MapEntry(key, value.toJson()));
}

class ArrayError extends ValidationError {
  const ArrayError(this.items);

  @override
  final Map<int, ValidationError>? items;

  @override
  String? get message => null;

  @override
  Map<String, ValidationError>? get fields => null;

  @override
  Map<String, dynamic> toJson() =>
      items!.map((key, value) => MapEntry(key.toString(), value.toJson()));
}