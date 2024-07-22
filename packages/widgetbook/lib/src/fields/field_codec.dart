class FieldCodec<T> {
  const FieldCodec({
    required this.toParam,
    required this.toValue,
  });

  /// Encoder for converting value of type [T] to a query parameter.
  final String Function(T value) toParam;

  /// Decoders for converting a query parameter to a value of type [T].
  final T? Function(String? param) toValue;

  /// Encodes a query group into a JSON-like representation.
  ///
  /// Example:
  ///
  /// ```
  /// final queryGroup = {
  ///   'foo': 'bar',
  ///   'baz': 'qux',
  /// };
  ///
  /// final encoded = FieldCodec.encodeQueryGroup(queryGroup);
  ///
  /// print(encoded); // {foo:bar,baz:qux}
  /// ```
  static String encodeQueryGroup(Map<String, String> group) {
    final pairs = group.entries.map((entry) {
      final String encodedKey = Uri.encodeComponent(entry.key);
      return '$encodedKey:${entry.value}';
    });
    return '{${pairs.join(',')}}';
  }

  /// Decodes a query group encoded value back to a [Map].
  static Map<String, String> decodeQueryGroup(String? group) {
    if (group == null) return {};

    final params = group.substring(1, group.length - 1).split(',');

    /// Exception handling for cases where the split character ',' is included in the QueryParams string,
    /// resulting in key-value pairs not being paired correctly.
    /// Example Case:
    ///
    /// ```
    /// final queryGroup = {
    ///   'foo': 'bar',
    ///   'amount': '500,000',
    /// };
    /// ```
    return Map<String, String>.fromEntries(
      params.map(
        (param) {
          try {
            final parts = param.split(':');
            final String decodedKey = Uri.decodeComponent(parts[0]);
            final String value = parts[1];
            if (value.isNotEmpty) {
              return MapEntry(decodedKey, value);
            } else {
              return null;
            }
          } catch (e) {
            return null;
          }
        }
      ).whereType<MapEntry<String, String>>(),
    );
  }
}
