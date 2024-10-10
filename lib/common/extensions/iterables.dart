part of '../common.dart';

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) value, {T? orElse}) {
    for (var element in this) {
      if (value(element)) return element;
    }

    if (orElse != null) return orElse;

    return null;
  }

  bool isContainsOnlyOneType (Type type) {
    final types = map((e) => e is Widget ? Widget : e.runtimeType).toSet();
    return types.isEmpty || (types.contains(type) && types.length == 1);
  }
}