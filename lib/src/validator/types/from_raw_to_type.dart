import '../../../ez_validator.dart';

extension CommonFromRawExtensions<T> on EzValidator<T> {
  /// Parse from a String → int
  EzValidator<int> fromStringToInt() {
    return (this as EzValidator<int>).fromRaw<String>((s) => int.parse(s));
  }

  /// Parse from a String → double
  EzValidator<double> fromStringToDouble() {
    return (this as EzValidator<double>)
        .fromRaw<String>((s) => double.parse(s));
  }

  /// Parse from a String → num
  EzValidator<num> fromStringToNum() {
    return (this as EzValidator<num>).fromRaw<String>((s) => num.parse(s));
  }

  /// Parse from a String → DateTime
  EzValidator<DateTime> fromStringToDate() {
    return (this as EzValidator<DateTime>)
        .fromRaw<String>((s) => DateTime.parse(s));
  }

  /// Parse from dynamic (int, double, String) → String
  EzValidator<String> coerceToString() {
    return (this as EzValidator<String>).fromRaw<dynamic>((v) => v.toString());
  }

  /// Parse from String → bool (accepts "true"/"false", "1"/"0")
  EzValidator<bool> fromStringToBool() {
    return (this as EzValidator<bool>).fromRaw<String>((s) {
      final lower = s.toLowerCase().trim();
      if (lower == 'true' || lower == '1') return true;
      if (lower == 'false' || lower == '0') return false;
      throw FormatException("Invalid boolean string: $s");
    });
  }
}

extension CommonFromRawListExtensions<T> on EzValidator<T> {
  /// Parse from List<String> → List<int>
  EzValidator<List<int>> fromStringListToIntList() {
    return (this as EzValidator<List<int>>).fromRaw<List<dynamic>>(
      (list) => list.map((e) => int.parse(e.toString())).toList(),
    );
  }

  /// Parse from List<String> → List<double>
  EzValidator<List<double>> fromStringListToDoubleList() {
    return (this as EzValidator<List<double>>).fromRaw<List<dynamic>>(
      (list) => list.map((e) => double.parse(e.toString())).toList(),
    );
  }

  /// Parse from List<String> → List<num>
  EzValidator<List<num>> fromStringListToNumList() {
    return (this as EzValidator<List<num>>).fromRaw<List<dynamic>>(
      (list) => list.map((e) => num.parse(e.toString())).toList(),
    );
  }

  /// Parse from List<String> → List<DateTime>
  EzValidator<List<DateTime>> fromStringListToDateList() {
    return (this as EzValidator<List<DateTime>>).fromRaw<List<dynamic>>(
      (list) => list.map((e) => DateTime.parse(e.toString())).toList(),
    );
  }

  /// Parse from List<dynamic> → List<String>
  EzValidator<List<String>> coerceToStringList() {
    return (this as EzValidator<List<String>>).fromRaw<List<dynamic>>(
      (list) => list.map((e) => e.toString()).toList(),
    );
  }

  /// Parse from List<String> → List<bool>
  EzValidator<List<bool>> fromStringListToBoolList() {
    return (this as EzValidator<List<bool>>).fromRaw<List<dynamic>>(
      (list) => list.map((e) {
        final s = e.toString().toLowerCase().trim();
        if (s == 'true' || s == '1') return true;
        if (s == 'false' || s == '0') return false;
        throw FormatException("Invalid boolean string: $e");
      }).toList(),
    );
  }
}
