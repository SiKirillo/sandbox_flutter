part of '../../common.dart';

class WhitespaceInputFormatter extends TextInputFormatter {
  static final uniqueWhitespaceFormat = RegExp(r'\s{2,}');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    TextSelection newSelection = newValue.selection;

    if (newValue.text.contains(uniqueWhitespaceFormat)) {
      newText = newValue.text.replaceAll(uniqueWhitespaceFormat, ' ');
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

class UncommonSymbolsInputFormatter extends TextInputFormatter {
  static final uniqueUncommonFormat = RegExp(r'[\r\n\t\f\v]');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    TextSelection newSelection = newValue.selection;

    if (newValue.text.contains(uniqueUncommonFormat)) {
      newText = newValue.text.replaceAll(uniqueUncommonFormat, '');
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

class OverflowInputFormatter extends TextInputFormatter {
  final int maxSymbols;
  final Function(String) onOverflow;

  const OverflowInputFormatter({
    required this.maxSymbols,
    required this.onOverflow,
  });

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    TextSelection newSelection = newValue.selection;

    /// Check whether text has been inserted from the clipboard or typed with keyboard
    if (newText.length - oldValue.text.length > 1) {
      onOverflow(newText);
    } else if (newText.length > maxSymbols) {
      onOverflow(newText.replaceFirst(oldValue.text, ''));
    }

    return TextEditingValue(
      text: newText,
      selection: newSelection,
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  static const phoneNumberPrefix = '+998';

  static String format(String phone) {
    String formatted = phone.replaceAll(RegExp(r'\D'), '');
    if (formatted.length > 9) {
      formatted = formatted.substring(0, 9);
    }

    if (formatted.isEmpty) return '';
    if (formatted.length < 3) {
      return '(${formatted.substring(0, formatted.length)}';
    }

    if (formatted.length < 6) {
      return '(${formatted.substring(0, 2)}) ${formatted.substring(2)}';
    }

    if (formatted.length < 8) {
      return '(${formatted.substring(0, 2)}) ${formatted.substring(2, 5)}-${formatted.substring(5)}';
    }

    return '(${formatted.substring(0, 2)}) ${formatted.substring(2, 5)}-${formatted.substring(5, 7)}-${formatted.substring(7)}';
  }

  /// Return string in custom format '+998 (XX) XXX-XX-XX'
  static String formatForValidation(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 9) return '';
    return '$phoneNumberPrefix (${digits.substring(0, 2)}) ${digits.substring(2, 5)}-${digits.substring(5, 7)}-${digits.substring(7, 9)}';
  }

  static String toNumberOnly(String phone) {
    final formatted = PhoneNumberFormatter.format(phone);
    return formatted.replaceAll(RegExp(r'\D'), '');
  }

  static String toJson(String phone) {
    final formatted = phone.replaceAll(RegExp(r'\D'), '');
    return formatted.length > 9 ? '+$formatted' : '${PhoneNumberFormatter.phoneNumberPrefix}$formatted';
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp(r'\D'), '');
    final formatted = format(newText);

    /// Update cursor position
    int digitsBeforeCursor = 0;
    for (int i = 0; i < newValue.selection.baseOffset && i < newValue.text.length; i++) {
      if (RegExp(r'\d').hasMatch(newValue.text[i])) {
        digitsBeforeCursor++;
      }
    }

    int formattedCursor = 0;
    int digitsCount = 0;
    while (formattedCursor < formatted.length && digitsCount < digitsBeforeCursor) {
      if (RegExp(r'\d').hasMatch(formatted[formattedCursor])) {
        digitsCount++;
      }
      formattedCursor++;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formattedCursor),
    );
  }
}

class LengthLimitingTextFieldFormatterFixed extends LengthLimitingTextInputFormatter {
  LengthLimitingTextFieldFormatterFixed(int super.maxLength);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (maxLength == null) {
      return newValue;
    }

    if (maxLength! > 0 && newValue.text.characters.length > maxLength!) {
      if (oldValue.text.characters.length == maxLength) {
        return oldValue;
      }

      // ignore: invalid_use_of_visible_for_testing_member
      return LengthLimitingTextInputFormatter.truncate(newValue, maxLength!);
    }

    return newValue;
  }
}
