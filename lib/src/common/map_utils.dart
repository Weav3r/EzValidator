/// Recursively converts any map with dynamic keys to Map<String, dynamic>.
/// Also recurses into nested maps and lists.
dynamic mapToStringKeyed(dynamic input) {
  if (input is Map) {
    return input.map((k, v) => MapEntry(
        k.toString(), mapToStringKeyed(v)
    ));
  } else if (input is List) {
    return input.map(mapToStringKeyed).toList();
  }
  return input;
}