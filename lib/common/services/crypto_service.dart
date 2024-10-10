part of '../common.dart';

class CryptoService {
  static String generateHash256(String value) {
    final bytes = utf8.encode(value);
    return sha256.convert(bytes).toString();
  }
}