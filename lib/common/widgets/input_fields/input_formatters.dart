part of '../../common.dart';

class WhitespaceInputFormatter extends TextInputFormatter {
  static final uniqueWhitespaceFormat = RegExp(r'\s{2,}');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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

// class ParentCodeInputFormatter extends TextInputFormatter {
//   static const uniqueInvisibleChar = '*';
//
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     String newText = newValue.text;
//     TextSelection newSelection = newValue.selection;
//
//     if (newValue.text.contains(uniqueInvisibleChar)) {
//       newText = newValue.text.split('').where((element) => element != uniqueInvisibleChar).join();
//       newSelection = newValue.selection.copyWith(
//         baseOffset: newText.length,
//         extentOffset: newText.length,
//       );
//     }
//
//     return TextEditingValue(
//       text: newText,
//       selection: newSelection,
//     );
//   }
// }

class OverflowInputFormatter extends TextInputFormatter {
  final int maxSymbols;
  final Function(String) onOverflow;

  const OverflowInputFormatter({
    required this.maxSymbols,
    required this.onOverflow,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;
    TextSelection newSelection = newValue.selection;

    if (newValue.text.length > maxSymbols) {
      onOverflow(newValue.text.substring(newValue.text.length - maxSymbols));
    }

    return TextEditingValue(
      text: newText,
      selection: newSelection,
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  static const phoneNumberPrefix = '+ 375';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.trim().toDigitsOnly();
    String formattedText = newText;

    if (newText.length <= 3) {
      formattedText = phoneNumberPrefix;
    }

    if (newText.length > 3) {
      final suffix = newText.substring(3);
      formattedText = '$phoneNumberPrefix ($suffix';
    }

    if (newText.length > 5) {
      final suffix = newText.substring(5);
      formattedText = '${formattedText.substring(0, 9)}) $suffix';
    }

    if (newText.length > 8) {
      final suffix = newText.substring(8);
      formattedText = '${formattedText.substring(0, 14)}-$suffix';
    }

    if (newText.length > 10) {
      final suffix = newText.substring(10);
      formattedText = '${formattedText.substring(0, 17)}-$suffix';
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class DecimalTransferFormatter extends TextInputFormatter {
  final int decimalRange;

  const DecimalTransferFormatter({
    required this.decimalRange,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;
    TextSelection newSelection = newValue.selection;

    if (newText.contains(',') && newText.substring(newText.indexOf(',') + 1).length > decimalRange) {
      newText = newText.substring(0, newText.indexOf(',') + 3);
      newSelection = newValue.selection.copyWith(
        baseOffset: newText.length,
        extentOffset: newText.length,
      );
    }

    if (newText.startsWith(',') && newValue.selection.baseOffset != 0) {
      newText = newText.replaceFirst(',', '0,');
      newSelection = newValue.selection.copyWith(
        baseOffset: newText.length,
        extentOffset: newText.length,
      );
    }

    return TextEditingValue(
      text: newText,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

class CurrencyTransferFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;
    TextSelection newSelection = newValue.selection;

    if (newSelection.baseOffset == 0) {
      return newValue;
    }

    if (newText.contains('.')) {
      newText = newText.replaceAll('.', ',');
    }

    final firstDotIndex = newText.indexOf('.');
    if (firstDotIndex != newText.lastIndexOf('.')) {
      while (firstDotIndex != newText.lastIndexOf('.')) {
        newText = newText.replaceRange(newText.lastIndexOf('.'), newText.lastIndexOf('.') + 1, '');
      }

      newSelection = newValue.selection.copyWith(
        baseOffset: newText.length,
        extentOffset: newText.length,
      );
    }

    return TextEditingValue(
      text: newText,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

class LengthLimitingTextFieldFormatterFixed extends LengthLimitingTextInputFormatter {
  LengthLimitingTextFieldFormatterFixed(int super.maxLength);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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