import 'dart:math';

import 'package:flutter/services.dart';

class ResidentRegistrationBackFormatter extends TextInputFormatter {
  ResidentRegistrationBackFormatter({
    required this.getRawValue,
    required this.onChangedRawValue,
    this.maxLength = 7,
  });

  final String Function() getRawValue;
  final ValueChanged<String> onChangedRawValue;
  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var rawValue = getRawValue();
    final oldText = oldValue.text;
    final newText = newValue.text;

    if (newText.isEmpty) {
      rawValue = '';
    } else {
      final diff = newText.length - oldText.length;
      if (diff > 0) {
        final addedText = newText.substring(oldText.length);
        final digits = addedText.replaceAll(RegExp(r'[^0-9]'), '');
        if (digits.isNotEmpty && rawValue.length < maxLength) {
          rawValue = (rawValue + digits);
          if (rawValue.length > maxLength) {
            rawValue = rawValue.substring(0, maxLength);
          }
        }
      } else if (diff < 0) {
        final removeCount = diff.abs();
        final nextLength = max(0, rawValue.length - removeCount);
        rawValue = rawValue.substring(0, nextLength);
      } else {
        final digits = newText.replaceAll(RegExp(r'[^0-9]'), '');
        if (digits.isNotEmpty &&
            digits.length <= maxLength &&
            digits != rawValue) {
          rawValue = digits;
        }
      }
    }

    onChangedRawValue(rawValue);

    final masked = _mask(rawValue);
    return TextEditingValue(
      text: masked,
      selection: TextSelection.collapsed(offset: masked.length),
    );
  }

  String _mask(String value) {
    if (value.isEmpty) {
      return '';
    }
    if (value.length == 1) {
      return value;
    }
    return '${value.substring(0, 1)}${'*' * (value.length - 1)}';
  }
}
