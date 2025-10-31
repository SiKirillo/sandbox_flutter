part of '../../common.dart';

class CustomOtpCodeInputField extends StatefulWidget {
  final String? initialValue;
  final String? errorText;
  final int count;
  final bool isDisabled, isOnError;
  final CustomInputFieldOptions options;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  const CustomOtpCodeInputField({
    super.key,
    this.initialValue,
    this.errorText,
    this.count = OtpCodeValidator.minSymbolsRule,
    this.isDisabled = false,
    this.isOnError = false,
    this.options = const CustomInputFieldOptions(),
    this.onChanged,
    this.onFieldSubmitted,
  }) : assert(count >= 0);

  static final globalKey = GlobalKey<_CustomOtpCodeInputFieldState>();

  @override
  State<CustomOtpCodeInputField> createState() => _CustomOtpCodeInputFieldState();
}

class _CustomOtpCodeInputFieldState extends State<CustomOtpCodeInputField> with sms.CodeAutoFill {
  final _codeControllers = <TextEditingController>[];
  final _codeFocusNodes = <FocusNode>[];

  String? _appSignature;
  bool _isPasteEvent = false;

  @override
  void initState() {
    super.initState();
    final inviteParentCodeFormatted = List<String?>.filled(widget.count, null);
    if (widget.initialValue != null) {
      inviteParentCodeFormatted.setAll(0, widget.initialValue!.split('').take(widget.count));
    }

    _codeControllers.addAll(List.generate(
      widget.count,
      (index) => TextEditingController(
        text: inviteParentCodeFormatted[index],
      ),
    ));
    _codeFocusNodes.addAll(List.generate(
      widget.count,
      (index) => FocusNode(),
    ));

    listenForCode();

    sms.SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        _appSignature = signature;
      });
    });
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  void clear() {
    for (final controller in _codeControllers) {
      controller.clear();
    }
  }

  @override
  void codeUpdated() {
    for (int i = 0; i < _codeControllers.length; i++) {
      _codeControllers[i].text = code?[i] ?? '';
    }

    if (widget.onChanged != null) {
      widget.onChanged!(_codeControllers.map((controller) => controller.value.text).join());
    }

    final allInputFieldsValue = _codeControllers.map((controller) => controller.value.text).join();
    if (_codeControllers.length == allInputFieldsValue.length) {
      FocusManager.instance.primaryFocus?.unfocus();
      _onFieldSubmittedHandler();
    }
  }

  void _onChangedHandler(int index, String value) {
    if (value.length == 1) {
      if (index < _codeControllers.length - 1 && !_isPasteEvent) {
        FocusScope.of(context).requestFocus(_codeFocusNodes[index + 1]);
      }
    }

    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_codeFocusNodes[index - 1]);
      _codeControllers[index - 1].selection = TextSelection.fromPosition(
        TextPosition(offset: _codeControllers[index - 1].text.length),
      );
    }

    if (widget.onChanged != null) {
      widget.onChanged!(_codeControllers.map((controller) => controller.value.text).join());
    }

    _isPasteEvent = false;
    _onFieldSubmittedHandler();
  }

  void _onEditingCompleteHandler(int index) {
    if (index == _codeControllers.length - 1) {
      FocusManager.instance.primaryFocus?.unfocus();
    } else {
      FocusScope.of(context).requestFocus(_codeFocusNodes[index + 1]);
    }
  }

  void _onFieldSubmittedHandler() {
    if (widget.onFieldSubmitted == null) return;

    final allInputFieldsValue = _codeControllers.map((controller) => controller.value.text).join();
    if (_codeControllers.length == allInputFieldsValue.length) {
      widget.onFieldSubmitted!(allInputFieldsValue);
    }
  }

  void _onOverflowHandler(int index, String value) {
    int j = index;
    int x = 0;

    if (value.length > 1) {
      _isPasteEvent = true;

      do {
        _codeControllers[j].text = value[x];
        j++;
        x++;
      } while (j < _codeControllers.length && x < value.length);
    } else {
      if (j >= _codeControllers.length) {
        return;
      }

      do {
        _codeControllers[j].text = value[x];
        j++;
        x++;
      } while (j < math.min(value.length, _codeControllers.length - index - 1));
    }

    if (widget.onChanged != null) {
      widget.onChanged!(_codeControllers.map((controller) => controller.value.text).join());
    }

    final allInputFieldsValue = _codeControllers.map((controller) => controller.value.text).join();
    if (_codeControllers.length == allInputFieldsValue.length) {
      FocusManager.instance.primaryFocus?.unfocus();
      _onFieldSubmittedHandler();
    } else {
      FocusScope.of(context).requestFocus(_codeFocusNodes[math.min(j, _codeControllers.length - 1)]);
    }
  }

  KeyEventResult _onKeyEventHandler(int index, KeyEvent event) {
   if (event is KeyUpEvent) {
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.goBack) {
      FocusManager.instance.primaryFocus?.unfocus();
      return KeyEventResult.handled;
    }

    final isBackspacePressed = event.logicalKey == LogicalKeyboardKey.backspace;
    if (isBackspacePressed) {
      if (event is KeyRepeatEvent) {
        return KeyEventResult.handled;
      }

      if (index > 0 && _codeControllers[index].value.text.isEmpty) {
        FocusScope.of(context).requestFocus(_codeFocusNodes[index - 1]);
      }
    }

    return KeyEventResult.ignored;
  }

  List<Widget> _buildInputFieldBody() {
    final inputFieldElements = <Widget>[];
    for (int i = 0; i < _codeControllers.length; i++) {
      inputFieldElements.add(SizedBox(
        key: ValueKey(_codeControllers[i].hashCode),
        width: 41.0,
        child: _OtpCodeInputTextField(
          controller: _codeControllers[i],
          focusNode: _codeFocusNodes[i],
          isDisabled: widget.isDisabled,
          isOnError: widget.errorText != null || widget.isOnError,
          inputAction: i == _codeControllers.length - 1
              ? TextInputAction.send
              : TextInputAction.next,
          onChanged: (value) => _onChangedHandler(i, value),
          onEditingComplete: () => _onEditingCompleteHandler(i),
          onFieldSubmitted: (value) => _onFieldSubmittedHandler(),
          onOverflow: (value) => _onOverflowHandler(i, value),
          onKeyEvent: (event) => _onKeyEventHandler(i, event),
        ),
      ));

      if (i + 1 < _codeControllers.length) {
        inputFieldElements.add(SizedBox(width: 8.0));
      }
    }

    return inputFieldElements;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: ColorConstants.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildInputFieldBody(),
          ),
        ),
        if (widget.errorText != null)
          SizedBox(
            height: 40.0,
            child: Center(
              child: CustomText(
                text: widget.errorText!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.0,
                  color: Theme.of(context).inputDecorationTheme.errorBorder?.borderSide.color,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _OtpCodeInputTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool isDisabled, isOnError;
  final TextInputAction inputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<bool>? onFocusChange;
  final ValueChanged<String>? onOverflow;
  final Function(KeyEvent)? onKeyEvent;

  const _OtpCodeInputTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.isDisabled = false,
    this.isOnError = false,
    this.inputAction = TextInputAction.done,
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.onFieldSubmitted,
    this.onFocusChange,
    this.onOverflow,
    this.onKeyEvent,
  });

  @override
  State<_OtpCodeInputTextField> createState() => _OtpCodeInputTextFieldState();
}

class _OtpCodeInputTextFieldState extends State<_OtpCodeInputTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    widget.controller.addListener(_checkInputFieldStatus);
    _checkInputFieldStatus();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkInputFieldStatus);
    super.dispose();
  }

  void _checkInputFieldStatus() {
    if (!mounted) return;
    setState(() {});
  }

  void _onChangedHandler(String value) {
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  void _onFocusChangeHandler(bool value) async {
    if (widget.onFocusChange != null) {
      widget.onFocusChange!(value);
    }
  }

  void _onOverflowHandler(String value) {
    if (widget.onOverflow != null) {
      widget.onOverflow!(value);
    }
  }

  KeyEventResult _onKeyEventHandler(FocusNode focus, KeyEvent event) {
    if (widget.onKeyEvent != null) {
      return widget.onKeyEvent!(event);
    }

    return KeyEventResult.ignored;
  }

  TextStyle _getTextStyle() {
    final textStyle = Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(
      color: ColorConstants.textFieldText(),
      decorationThickness: 0.0,
    );

    /// On disabled
    if (widget.isDisabled) {
      return textStyle.copyWith(
        color: ColorConstants.textFieldTextDisable(),
      );
    }

    return textStyle;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: _onFocusChangeHandler,
      onKeyEvent: _onKeyEventHandler,
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: TextInputType.number,
        textInputAction: widget.inputAction,
        style: _getTextStyle(),
        decoration: InputDecoration(
          isDense: true,
          border: Theme.of(context).inputDecorationTheme.border,
          enabledBorder: widget.isOnError
              ? Theme.of(context).inputDecorationTheme.errorBorder
              : null,
          focusedBorder: widget.isOnError
              ? Theme.of(context).inputDecorationTheme.errorBorder
              : null,
          disabledBorder: Theme.of(context).inputDecorationTheme.disabledBorder,
          contentPadding: SizeConstants.defaultTextInputOtpPadding,
        ),
        /// Don't ruin formatters order
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
          FilteringTextInputFormatter.allow(RegExp(r'\d')),
          UncommonSymbolsInputFormatter(),
          OverflowInputFormatter(
            maxSymbols: 1,
            onOverflow: _onOverflowHandler,
          ),
          LengthLimitingTextInputFormatter(1),
        ],
        cursorColor: widget.isOnError
            ? Theme.of(context).inputDecorationTheme.errorBorder?.borderSide.color
            : Theme.of(context).inputDecorationTheme.focusedBorder?.borderSide.color,
        cursorWidth: 1.0,
        cursorOpacityAnimates: !kIsWeb,
        maxLines: 1,
        textAlign: TextAlign.center,
        enabled: !widget.isDisabled,
        onChanged: _onChangedHandler,
        onEditingComplete: widget.onEditingComplete,
        onTap: widget.onTap,
        onFieldSubmitted: widget.onFieldSubmitted,
      ),
    );
  }
}
