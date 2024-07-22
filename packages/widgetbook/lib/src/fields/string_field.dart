import 'package:flutter/material.dart';

import 'field.dart';
import 'field_codec.dart';
import 'field_type.dart';

/// [Field] that builds [TextFormField] for [String] values.
class StringField extends Field<String> {
  StringField({
    required super.name,
    super.initialValue = '',
    this.maxLines,
    @deprecated super.onChanged,
  }) : super(
          type: FieldType.string,
          codec: FieldCodec(
            toParam: (value) => Uri.encodeComponent(value),
            toValue: (param) {
              if (param == null) return null;

              /// When using Uri.decodeComponent, non-alphanumeric characters can cause errors.
              /// This prevents "Invalid argument(s): Illegal percent encoding in URI" errors.
              /// If decoding fails, the string is decoded after the encoding attempt.
              try {
                return Uri.decodeComponent(param);
              } catch (e) {
                String encodedParam = Uri.encodeComponent(param);
                return Uri.decodeComponent(encodedParam);
              }
            },
          ),
        );

  final int? maxLines;

  @override
  Widget toWidget(BuildContext context, String group, String? value) {
    return TextFormField(
      maxLines: maxLines,
      initialValue: value ?? initialValue,
      onChanged: (value) => updateField(context, group, value),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'maxLines': maxLines,
    };
  }
}
