part of '../../common.dart';

class CustomProgressDialog extends StatefulWidget {
  final String title;
  final dynamic content;
  final Duration? autoCloseDuration;
  final Function(bool, dynamic)? onPopInvoked;
  final bool isCanPop;

  const CustomProgressDialog({
    super.key,
    required this.title,
    required this.content,
    this.autoCloseDuration,
    this.onPopInvoked,
    this.isCanPop = false,
  }) : assert(content is Widget || content is String);

  @override
  State<CustomProgressDialog> createState() => _CustomProgressDialogState();
}

class _CustomProgressDialogState extends State<CustomProgressDialog> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.autoCloseDuration != null) {
      _timer = Timer(widget.autoCloseDuration!, () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  Widget _buildContentWidget() {
    if (widget.content is Widget) {
      return widget.content;
    }

    return CustomText(
      text: widget.content,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        height: 16.0 / 12.0,
      ),
      textAlign: TextAlign.center,
      maxLines: 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.isCanPop,
      onPopInvokedWithResult: widget.onPopInvoked,
      child: AlertDialog(
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).dialogTheme.surfaceTintColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        titlePadding: EdgeInsets.zero,
        title: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                    bottom: 24.0,
                    left: 28.0,
                    right: 28.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: CustomText(
                          text: widget.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: ColorConstants.textBlack(),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Flexible(
                        child: _buildContentWidget(),
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      const CustomProgressIndicator(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
