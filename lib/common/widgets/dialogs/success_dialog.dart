part of '../../common.dart';

class CustomSuccessDialog extends StatefulWidget {
  final String title;
  final dynamic content;
  final String? iconSrc;
  final Duration? autoCloseDuration;
  final Function(bool, dynamic)? onPopInvoked;
  final bool isCanPop;

  const CustomSuccessDialog({
    super.key,
    required this.title,
    required this.content,
    this.iconSrc,
    this.autoCloseDuration,
    this.onPopInvoked,
    this.isCanPop = true,
  }) : assert(content is Widget || content is String);

  @override
  State<CustomSuccessDialog> createState() => _CustomSuccessDialogState();
}

class _CustomSuccessDialogState extends State<CustomSuccessDialog> {
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

  Widget _buildSuccessIconWidget() {
    if (widget.iconSrc != null) {
      if (widget.iconSrc!.contains(ImageConstants.svgPrefix)) {
        return SvgPicture.asset(
          widget.iconSrc!,
        );
      } else {
        return Image.asset(
          widget.iconSrc!,
        );
      }
    }

    return SvgPicture.asset(
      'ImageConstants.icSuccess',
    );
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
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        titlePadding: EdgeInsets.zero,
        title: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 28.0,
                horizontal: 20.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox.square(
                    dimension: 70.0,
                    child: _buildSuccessIconWidget(),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Flexible(
                    child: CustomText(
                      text: widget.title,
                      style: Theme.of(context).dialogTheme.titleTextStyle?.copyWith(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
