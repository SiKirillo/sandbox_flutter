import 'package:flutter/services.dart';

class SpaceTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final spaceRegExp = RegExp(r'[\r\n\t\f\v ]');
    String newText = newValue.text;
    TextSelection newSelection = newValue.selection;

    if (newValue.text.contains(spaceRegExp)) {
      newText = newValue.text.replaceAll(spaceRegExp, '');
      newSelection = newValue.selection.copyWith(
        baseOffset: newText.length,
        extentOffset: newText.length,
      );
    }

    return TextEditingValue(
      text: newText,
      selection: newSelection,
    );
  }
}