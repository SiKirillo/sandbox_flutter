import 'package:flutter/material.dart';

/// Extensions that apply to all iterables.
extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test, {T? orElse}) {
    for (var element in this) {
      if (test(element)) return element;
    }

    if (orElse != null) return orElse;

    return null;
  }

  bool isContainsOnlyOneType (Type type) {
    final types = map((e) => e is Widget ? Widget : e.runtimeType).toSet();
    return types.isEmpty || (types.contains(type) && types.length == 1);
  }
}