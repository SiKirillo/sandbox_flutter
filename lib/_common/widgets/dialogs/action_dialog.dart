part of '../../common.dart';

class CustomActionDialog extends StatefulWidget {
  final dynamic title;
  final dynamic content;
  final String? cancelText, actionText;
  final Function()? onCancel, onAction;
  final Function(bool, dynamic)? onPopInvoked;
  final bool isCanPop;
  final CustomActionDialogType type;
  final BorderRadiusGeometry borderRadius;
  final Color? cancelButtonColor, actionButtonColor;
  final bool isCriticalAction;
  final bool isHorizontalPosition;
  final bool isReversedPosition;

  const CustomActionDialog({
    super.key,
    required this.title,
    required this.content,
    this.cancelText,
    this.actionText,
    this.onCancel,
    this.onAction,
    this.onPopInvoked,
    this.isCanPop = true,
    this.type = CustomActionDialogType.none,
    this.borderRadius = const BorderRadius.all(Radius.circular(24.0)),
    this.cancelButtonColor,
    this.actionButtonColor,
    this.isCriticalAction = false,
    this.isHorizontalPosition = false,
    this.isReversedPosition = false,
  })  : assert(title is Widget || title is String),
        assert(content is Widget || content is String || content == null);

  @override
  State<CustomActionDialog> createState() => _CustomActionDialogState();
}

class _CustomActionDialogState extends State<CustomActionDialog> {
  bool _isRequestInProgress = false;
  bool get _isMaterialDesign => kIsWeb || Platform.isAndroid;

  /// Измеряет ширину текста с учетом стиля
  double _measureTextWidth(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    textPainter.layout();
    return textPainter.width;
  }

  /// Определяет оптимальную ориентацию кнопок на основе длины текста
  bool _shouldUseHorizontalLayout() {
    if (!widget.isHorizontalPosition) return false;

    // Получаем стиль для кнопок (точно такой же как в _buildMaterialButton)
    final buttonStyle = Theme.of(context).textTheme.displayMedium?.copyWith(
          height: 1.0,
          color: _getButtonColor(false),
        );

    if (buttonStyle == null) return false;

    // Измеряем ширину текста кнопок
    double totalTextWidth = 0;
    if (widget.cancelText != null) {
      totalTextWidth += _measureTextWidth(widget.cancelText!, buttonStyle);
    }
    if (widget.actionText != null) {
      totalTextWidth += _measureTextWidth(widget.actionText!, buttonStyle);
    }

    // Добавляем padding кнопок (8px с каждой стороны для каждой кнопки)
    final buttonCount = (widget.cancelText != null ? 1 : 0) + (widget.actionText != null ? 1 : 0);
    totalTextWidth += buttonCount * 16; // 8px * 2 стороны для каждой кнопки

    // Добавляем отступ между кнопками (если есть обе кнопки)
    if (widget.cancelText != null && widget.actionText != null) {
      totalTextWidth += 16; // SizedBox(width: 16.0)
    }

    // Максимальная ширина диалога: 280px
    // Actions padding: 8px с каждой стороны (fromLTRB(8.0, 0.0, 8.0, 8.0))
    // Доступная ширина для кнопок: 280 - 16 = 264px
    const availableWidth = 264.0;

    return totalTextWidth <= availableWidth;
  }

  Future<void> _onCancelHandler() async {
    if (_isRequestInProgress) return;
    if (widget.onCancel != null) {
      _isRequestInProgress = true;
      await widget.onCancel!();
      _isRequestInProgress = false;
    }

    Navigator.of(context).pop(false);
  }

  Future<void> _onActionHandler() async {
    if (_isRequestInProgress) return;
    if (widget.onAction != null) {
      _isRequestInProgress = true;
      await widget.onAction!();
      _isRequestInProgress = false;
    }

    Navigator.of(context).pop(true);
  }

  Color _getButtonColor(bool isAction) {
    /// Custom
    if (widget.cancelButtonColor != null && !isAction) {
      return widget.cancelButtonColor!;
    }

    if (widget.actionButtonColor != null && isAction) {
      return widget.actionButtonColor!;
    }

    /// Without color
    if (!isAction) {
      return ColorConstants.dialogCancel();
    }

    /// Critical
    if (widget.isCriticalAction) {
      return ColorConstants.dialogAction();
    }

    /// Default
    switch (widget.type) {
      case CustomActionDialogType.error:
        return ColorConstants.dialogAction();

      case CustomActionDialogType.info:
        return ColorConstants.dialogInfo();

      case CustomActionDialogType.none:
        return ColorConstants.dialogCancel();
    }
  }

  /// Widgets
  Widget _buildTitleWidget() {
    late final Widget title;
    if (widget.title is String) {
      if (_isMaterialDesign) {
        title = CustomText(
          text: widget.title,
          style: Theme.of(context).dialogTheme.titleTextStyle,
          maxLines: 3,
        );
      } else {
        title = CustomText(
          text: widget.title,
          style: Theme.of(context).dialogTheme.titleTextStyle?.copyWith(
                fontFamily: 'OpenSans',
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                height: 22.0 / 16.0,
              ),
          textAlign: TextAlign.center,
          maxLines: 3,
        );
      }
    } else {
      title = widget.title;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.type != CustomActionDialogType.none) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: SvgPicture.asset(
              widget.type == CustomActionDialogType.error ? ImageConstants.icError : ImageConstants.icInfo,
              height: 26.0,
              width: 26.0,
            ),
          ),
          SizedBox(height: 12.0),
        ],
        title,
      ],
    );
  }

  Widget _buildContentWidget() {
    if (widget.content is String) {
      if (_isMaterialDesign) {
        return CustomText(
          text: widget.content!,
          style: Theme.of(context).dialogTheme.contentTextStyle,
          maxLines: 10,
        );
      }

      return CustomText(
        text: widget.content!,
        style: Theme.of(context).dialogTheme.contentTextStyle?.copyWith(
              fontFamily: 'OpenSans',
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
              height: 18.0 / 13.0,
            ),
        maxLines: 10,
      );
    }

    return widget.content;
  }

  Widget _buildActionsWidget() {
    final shouldUseHorizontal = _shouldUseHorizontalLayout();

    if (shouldUseHorizontal) {
      final buttons = [
        if (widget.cancelText != null) _buildMaterialButton(widget.cancelText!, _onCancelHandler),
        if (widget.cancelText != null && widget.actionText != null) SizedBox(width: 16.0),
        if (widget.actionText != null) _buildMaterialButton(widget.actionText!, _onActionHandler, isAction: true),
      ];

      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: widget.isReversedPosition ? buttons.reversed.toList() : buttons,
      );
    }

    final buttons = [
      if (widget.cancelText != null)
        Align(
          alignment: Alignment.centerRight,
          child: _buildMaterialButton(widget.cancelText!, _onCancelHandler),
        ),
      if (widget.cancelText != null && widget.actionText != null) SizedBox(height: 16.0),
      if (widget.actionText != null)
        Align(
          alignment: Alignment.centerRight,
          child: _buildMaterialButton(widget.actionText!, _onActionHandler, isAction: true),
        ),
    ];

    return Column(
      children: widget.isReversedPosition ? buttons.reversed.toList() : buttons,
    );
  }

  Widget _buildMaterialButton(String text, VoidCallback onTap, {bool isAction = false}) {
    return CustomButton(
      content: text,
      onTap: onTap,
      options: CustomButtonOptions(
        height: 38.0,
        padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        splashColor: _getButtonColor(isAction),
        textStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
              height: 1.0,
              color: _getButtonColor(isAction),
            ),
      ),
      isExpanded: false,
    );
  }

  Widget _buildCupertinoButton(String text, VoidCallback onTap, {bool isAction = false}) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        overlayColor: WidgetStateColor.resolveWith((states) => ColorConstants.transparent),
      ),
      child: CustomText(
        text: text,
        style: Theme.of(context).dialogTheme.titleTextStyle?.copyWith(
              fontFamily: 'OpenSans',
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              height: 22.0 / 16.0,
              color: _getButtonColor(isAction),
            ),
      ),
    );
  }

  /// Dialogs
  Widget _buildMaterialDialog(BuildContext context) {
    final withActions = widget.cancelText != null || widget.actionText != null;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: widget.borderRadius),
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 280.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildTitleWidget(),
            ),
            if (widget.content != null) ...[
              SizedBox(height: 12.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildContentWidget(),
              ),
            ],
            if (withActions) ...[
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                child: _buildActionsWidget(),
              ),
            ] else ...[
              SizedBox(height: 14.0)
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCupertinoDialog(BuildContext context) {
    final buttons = [
      if (widget.cancelText != null) _buildCupertinoButton(widget.cancelText!, _onCancelHandler),
      if (widget.actionText != null) _buildCupertinoButton(widget.actionText!, _onActionHandler, isAction: true),
    ];

    return cupertino.CupertinoTheme(
      data: cupertino.CupertinoThemeData(
        brightness: Theme.of(context).brightness,
      ),
      child: cupertino.CupertinoAlertDialog(
        title: _buildTitleWidget(),
        content: _buildContentWidget(),
        actions: widget.isReversedPosition ? buttons.reversed.toList() : buttons,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.isCanPop,
      onPopInvokedWithResult: widget.onPopInvoked,
      child: _isMaterialDesign ? _buildMaterialDialog(context) : _buildCupertinoDialog(context),
    );
  }
}

enum CustomActionDialogType {
  error,
  info,
  none,
}
