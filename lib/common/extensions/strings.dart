part of '../common.dart';

extension StringExtension on String {
  String capitalize() {
    if (isEmpty || this == '') return '';
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}