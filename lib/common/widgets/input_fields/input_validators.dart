import 'package:email_validator/email_validator.dart' as email;

abstract class Validator<Params> {
  String? call(Params inputValue);
}

abstract class AsyncValidator<Params> {
  Future<String?> call(Params inputValue);
}

class PhoneNumberValidator extends Validator<String> {
  static final uniquePhoneFormat = RegExp(r'^[\d]+$');
  final int maxSymbols;

  PhoneNumberValidator({
    this.maxSymbols = 10,
  });

  @override
  String? call(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty) {
      return null;
    }

    if (inputValue.length != maxSymbols) {
      return 'Phone number should contain $maxSymbols digits';
    }

    if (!uniquePhoneFormat.hasMatch(inputValue)) {
      return 'Phone number should have only digits';
    }

    return null;
  }
}

class ZipCodeAsyncValidator extends AsyncValidator<String> {
  static final uniqueZipCodeFormat = RegExp(r'^[0-9]{5}(?:-[0-9]{4})?$');

  @override
  Future<String?> call(String? inputValue) async {
    if (inputValue == null || inputValue.isEmpty) {
      return null;
    }

    if (!uniqueZipCodeFormat.hasMatch(inputValue)) {
      return 'Zip code should contain 5 digits';
    }

    return null;
  }
}

class EmailValidator extends Validator<String> {
  static final uniqueEmailFormat = RegExp(r'^[\w\S]+$');

  @override
  String? call(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty) {
      return null;
    }

    if (!email.EmailValidator.validate(inputValue)) {
      return 'Invalid email format';
    }

    return null;
  }
}

class PasswordValidator extends Validator<String> {
  static final uniquePasswordFormat = RegExp(r'^[\w\S]+$');

  final int minSymbols;
  final int maxSymbols;

  PasswordValidator({
    this.minSymbols = 6,
    this.maxSymbols = 30,
  });

  @override
  String? call(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty) {
      return null;
    }

    if (!uniquePasswordFormat.hasMatch(inputValue)) {
      return 'Password should have only letters, digits and some symbols';
    }

    if (inputValue.length < minSymbols) {
      return 'Password should have at least $minSymbols symbols';
    }

    if (inputValue.length > maxSymbols) {
      return 'Password should have no more than $maxSymbols symbols';
    }

    return null;
  }
}

class PasswordConfirmValidator extends Validator<String> {
  final String compareWith;

  PasswordConfirmValidator({
    required this.compareWith,
  });

  @override
  String? call(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty) {
      return null;
    }

    if (compareWith.isEmpty) {
      return null;
    }

    if (compareWith.trim() != inputValue.trim()) {
      return 'Passwords are not equal';
    }

    return null;
  }
}

class NicknameValidator extends Validator<String> {
  static final uniqueNicknameFormat = RegExp(r'^[\w-.]+$');
  final int minSymbols;

  NicknameValidator({
    this.minSymbols = 3,
  });

  @override
  String? call(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty) {
      return null;
    }
    
    if (!uniqueNicknameFormat.hasMatch(inputValue)) {
      return 'Nickname should have only letters and digits';
    }

    if (inputValue.length < minSymbols) {
      return 'Nickname should have at least $minSymbols symbols';
    }

    return null;
  }
}

class NameValidator extends Validator<String> {
  static final uniqueNameFormat = RegExp(r'^[a-zA-Z]+$');

  @override
  String? call(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty) {
      return null;
    }

    if (!uniqueNameFormat.hasMatch(inputValue)) {
      return 'Name should have only letters';
    }

    return null;
  }
}