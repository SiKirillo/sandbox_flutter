part of '../../common.dart';

abstract class Validator<Params> {
  String? call(Params inputValue);
}

abstract class AsyncValidator<Params> {
  Future<String?> call(Params inputValue);
}

class EmailValidator extends Validator<String> {
  @override
  String? call(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty || inputValue == '') {
      return null;
    }

    if (!email.EmailValidator.validate(inputValue)) {
      return 'errors.validators.email.unique_format'.tr();
    }

    return null;
  }
}

class NameValidator extends Validator<String> {
  static final uniqueNameFormat = RegExp(r'^[a-zA-Zа-яА-ЯіІўЎёЁ\-_\s\d]+$');
  final int minSymbols;

  NameValidator({
    this.minSymbols = 4,
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

class PasswordCodeValidator extends Validator<String> {
  static final uniquePinFormat = RegExp(r'^[a-zA-Z-_\d]+$');

  final int minSymbols;
  final int maxSymbols;

  PasswordCodeValidator({
    this.minSymbols = 6,
    this.maxSymbols = 64,
  });

  @override
  String? call(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty || inputValue == '') {
      return null;
    }

    if (!uniquePinFormat.hasMatch(inputValue)) {
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

class PasswordRepeatCodeValidator extends Validator<String> {
  final String compareWith;

  PasswordRepeatCodeValidator({
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

class OtpCodeValidator extends Validator<String> {
  static final uniquePinFormat = RegExp(r'^\d+$');

  final int minSymbols;

  OtpCodeValidator({
    this.minSymbols = 6,
  });

  @override
  String? call(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty || inputValue == '') {
      return null;
    }

    if (!uniquePinFormat.hasMatch(inputValue)) {
      return 'errors.validators.confirmation_code.unique_format'.tr();
    }

    if (inputValue.length < minSymbols) {
      return 'errors.validators.confirmation_code.min_symbols'.plural(minSymbols, namedArgs: {'quantity': '$minSymbols'});
    }

    return null;
  }
}
