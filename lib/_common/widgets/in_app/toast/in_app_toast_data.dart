part of 'in_app_toast_provider.dart';

class InAppToastData {
  final int id;
  final ValueKey<String> key;
  final dynamic label;
  final dynamic description;
  final String? actionText;
  final VoidCallback? onAction;

  const InAppToastData({
    required this.id,
    required this.key,
    this.label,
    required this.description,
    this.actionText,
    this.onAction,
  }) :  assert(label is Widget || label is String || label == null),
        assert(description is Widget || description is String);

  factory InAppToastData.custom({
    required ValueKey<String> key,
    dynamic label,
    required dynamic description,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return InAppToastData(
      id: DateTime.now().hashCode,
      key: key,
      label: label,
      description: description,
      actionText: actionText,
      onAction: onAction,
    );
  }

  factory InAppToastData.failure({
    required ValueKey<String> key,
    dynamic label,
    required Failure failure,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return InAppToastData(
      id: DateTime.now().hashCode,
      key: key,
      label: label,
      description: failure.message,
      actionText: actionText,
      onAction: onAction,
    );
  }

  bool isEqual(InAppToastData? compare) {
    return id == compare?.id && key == compare?.key && label == compare?.label && description == compare?.description && actionText == compare?.actionText && onAction == compare?.onAction;
  }
}
