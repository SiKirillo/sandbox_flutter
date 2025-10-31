part of '../../common.dart';

abstract class Validator<Params> {
  String? call(Params inputValue);
}

abstract class AsyncValidator<Params> {
  Future<String?> call(Params inputValue);
}

// class EmailValidator extends Validator<String> {
//   @override
//   String? call(String? inputValue) {
//     if (inputValue == null || inputValue.isEmpty || inputValue == '') {
//       return null;
//     }
//
//     if (!email.EmailValidator.validate(inputValue)) {
//       return 'errors.validators.email.unique_format'.tr();
//     }
//
//     return null;
//   }
// }

class NameValidator extends Validator<String> {
  static final uniqueNameFormat = RegExp(r'[a-zA-Zа-яА-ЯіІўЎёЁ\-_\s\d]+');
  static const minSymbolsRule = 3;

  final int minSymbols;

  NameValidator({
    this.minSymbols = minSymbolsRule,
  });

  @override
  String? call(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty || inputValue == '') {
      return null;
    }

    if (!uniqueNameFormat.hasMatch(inputValue)) {
      return 'errors.validators.name.unique_format'.tr();
    }

    if (inputValue.length < minSymbols) {
      return 'errors.validators.name.min_symbols'.plural(minSymbols, namedArgs: {'quantity': '$minSymbols'});
    }

    return null;
  }
}

class PhoneNumberValidator extends Validator<String> {
  static final uniquePhoneFormat = RegExp(r'\+{1}\d{3}\s{1}\({1}\d{2}\){1}\s{1}\d{3}\-{1}\d{2}\-{1}\d{2}');

  @override
  String? call(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty || inputValue.trim() == PhoneNumberFormatter.phoneNumberPrefix) {
      return null;
    }

    if (!uniquePhoneFormat.hasMatch(inputValue)) {
      return 'errors.validators.phone.unique_format'.tr();
    }

    return null;
  }
}

class PasswordCodeValidator extends Validator<String> {
  static final atLeastOneDigitRule = RegExp(r'[\d]{1,}');
  static final atLeastOneLetterRule = RegExp(r'[a-zA-Z]{1,}');
  static final atLeastOneSymbolRule = RegExp(r'[\!\#\$\%\&\(\)\*\+\,\-\–\.\/\\\:\;\<\=\>\?\@\[\]\^\_\{\}\|\~]{1,}');

  static const minSymbolsRuleAuditor = 12;
  static const minSymbolsRuleSeller = 8;
  static const minSymbolsRuleTmr = 12;
  static const maxSymbolsRule = 64;

  final int minSymbols;
  final int maxSymbols;

  PasswordCodeValidator({
    required this.minSymbols,
    this.maxSymbols = maxSymbolsRule,
  });

  @override
  String? call(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty || inputValue == '') {
      return null;
    }

    final isHasMatch = atLeastOneDigitRule.hasMatch(inputValue) &&
        atLeastOneLetterRule.hasMatch(inputValue) &&
        atLeastOneSymbolRule.hasMatch(inputValue);
    if (!isHasMatch) {
      return 'errors.validators.password.unique_format'.tr();
    }

    if (inputValue.length < minSymbols) {
      return 'errors.validators.password.min_symbols'.plural(minSymbols, namedArgs: {'quantity': '$minSymbols'});
    }

    if (inputValue.length > maxSymbols) {
      return 'errors.validators.password.max_symbols'.plural(maxSymbols, namedArgs: {'quantity': '$maxSymbols'});
    }

    return null;
  }
}

class RepeatPasswordCodeValidator extends Validator<String> {
  final String compareWith;

  RepeatPasswordCodeValidator({
    required this.compareWith,
  });

  @override
  String? call(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty || inputValue == '') {
      return null;
    }

    if (compareWith.isEmpty) {
      return null;
    }

    if (compareWith.trim() != inputValue.trim()) {
      return 'errors.validators.password.not_equal'.tr();
    }

    return null;
  }
}

class NotEqualPasswordCodeValidator extends Validator<String> {
  final String compareWith;

  NotEqualPasswordCodeValidator({
    required this.compareWith,
  });

  @override
  String? call(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty || inputValue == '') {
      return null;
    }

    if (compareWith.isEmpty) {
      return null;
    }

    if (compareWith.trim() == inputValue.trim()) {
      return 'errors.validators.password.are_equal'.tr();
    }

    return null;
  }
}

class OtpCodeValidator extends Validator<String> {
  static final uniquePinFormat = RegExp(r'\d+');
  static const minSymbolsRule = 6;

  final int minSymbols;

  OtpCodeValidator({
    this.minSymbols = minSymbolsRule,
  });

  @override
  String? call(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty || inputValue == '') {
      return null;
    }

    if (!uniquePinFormat.hasMatch(inputValue)) {
      return 'errors.validators.otp_code.unique_format'.tr();
    }

    if (inputValue.length < minSymbols) {
      return 'errors.validators.otp_code.min_symbols'.plural(minSymbols, namedArgs: {'quantity': '$minSymbols'});
    }

    return null;
  }
}

class SumValidator extends Validator<String> {
  final int availablePoints;
  final int coefficient;

  SumValidator(this.availablePoints, this.coefficient);

  @override
  String? call(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty) {
      return null;
    }

    final sum = int.tryParse(inputValue.replaceAll(RegExp(r'[^0-9]'), ''));
    if (sum == null) {
      return 'certificates.top_up_section.bottom_sheet.invalid_number'.tr();
    }

    final coefficientSum = coefficient * sum;
    if (coefficientSum > availablePoints) {
      final formattedPoints = availablePoints;
      return 'certificates.top_up_section.bottom_sheet.invalid_amount'.plural(formattedPoints, namedArgs: {'amount': formattedPoints.toFormattedWithDots()}).tr();
    }

    return null;
  }
}
