part of '../common.dart';

class CustomPopupCard extends StatelessWidget {
  final Widget content;
  final Widget? actions;
  final CustomPopupCardOptions options;

  const CustomPopupCard({
    super.key,
    required this.content,
    this.actions,
    this.options = const CustomPopupCardOptions(),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: options.cardPadding,
      child: Stack(
        children: [
          Padding(
            padding: options.contentPadding,
            child: content,
          ),
          if (actions != null)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: options.actionsPadding,
                child: actions,
              ),
            ),
        ],
      ),
    );
  }
}

class CustomPopupCardOptions {
  final EdgeInsets cardPadding;
  final EdgeInsets contentPadding;
  final EdgeInsets actionsPadding;

  const CustomPopupCardOptions({
    this.cardPadding = EdgeInsets.zero,
    this.contentPadding = EdgeInsets.zero,
    this.actionsPadding = const EdgeInsets.only(
      top: 2.0,
      right: 2.0,
    ),
  });
}