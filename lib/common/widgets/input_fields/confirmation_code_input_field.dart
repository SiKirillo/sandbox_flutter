// ignore_for_file: unused_element

part of '../../common.dart';

class ConfirmationCodeInputField extends StatefulWidget {
  final String? initialValue;
  final int maxSymbols;
  final String? errorMessage;
  final bool isEnabled, isOnError;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;

  const ConfirmationCodeInputField({
    super.key,
    this.initialValue,
    this.maxSymbols = 6,
    this.errorMessage,
    this.isEnabled = true,
    this.isOnError = false,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  State<ConfirmationCodeInputField> createState() => _ConfirmationCodeInputFieldState();
}

class _ConfirmationCodeInputFieldState extends State<ConfirmationCodeInputField> {
  final _codeControllers = <TextEditingController>[];
  final _codeFocusNodes = <FocusNode>[];

  @override
  void initState() {
    super.initState();
    final inviteParentCodeFormatted = List<String?>.filled(widget.maxSymbols, null);
    if (widget.initialValue != null) {
      inviteParentCodeFormatted.setAll(0, widget.initialValue!.split('').take(widget.maxSymbols));
    }

    _codeControllers.addAll(List.generate(
      widget.maxSymbols,
      (index) => TextEditingController(
        text: inviteParentCodeFormatted[index],
      ),
    ));
    _codeFocusNodes.addAll(List.generate(
      widget.maxSymbols,
      (index) => FocusNode(),
    ));
  }

  @override
  void didUpdateWidget(covariant ConfirmationCodeInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue && widget.initialValue != null) {
      final inviteParentCodeFormatted = List<String?>.filled(widget.maxSymbols, null);
      inviteParentCodeFormatted.setAll(0, widget.initialValue!.split('').take(widget.maxSymbols));

      for (int i = 0; i < _codeControllers.length; i++) {
        if (inviteParentCodeFormatted[i] != null) {
          _codeControllers[i].text = inviteParentCodeFormatted[i]!;
        }
      }
    }
  }

  void _onChangedHandler(int index, String value) {
    if (value.length == 1) {
      if (index < _codeControllers.length - 1) {
        FocusScope.of(context).requestFocus(_codeFocusNodes[index + 1]);
      }
    }

    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_codeFocusNodes[index - 1]);
    }

    if (widget.onChanged != null) {
      widget.onChanged!(_codeControllers.map((controller) => controller.value.text).join());
    }

    final allInputFieldsValue = _codeControllers.map((controller) => controller.value.text).join();
    if (_codeControllers.length == allInputFieldsValue.length) {
      _onFieldSubmittedHandler(index);
    }
  }

  void _onEditingCompleteHandler(int index) {
    if (index == _codeControllers.length - 1) {
      FocusScope.of(context).unfocus();
    } else {
      FocusScope.of(context).requestFocus(_codeFocusNodes[index + 1]);
    }
  }

  Future<void> _onTapHandler() async {
    if (widget.isEnabled) {
      return;
    }

    await Clipboard.setData(ClipboardData(
      text: _codeControllers.map((controller) => controller.value.text).join(),
    ));
  }

  void _onFieldSubmittedHandler(int index) {
    if (widget.onFieldSubmitted == null) return;
    if (index == _codeControllers.length - 1) {
      final allInputFieldsValue = _codeControllers.map((controller) => controller.value.text).join();
      widget.onFieldSubmitted!(allInputFieldsValue);
    }
  }

  void _onOverflowHandler(int index, String value) {
    int j = index + 1;
    int x = 0;

    if (j >= _codeControllers.length) {
      return;
    }

    do {
      if (_codeControllers[j].value.text.isEmpty) {
        _codeControllers[j].text = value[x];
      }
      j++;
      x++;
    } while (j < math.min(value.length, _codeControllers.length - index - 1));

    if (widget.onChanged != null) {
      widget.onChanged!(_codeControllers.map((controller) => controller.value.text).join());
    }

    _onFieldSubmittedHandler(index + 1);
    FocusScope.of(context).requestFocus(_codeFocusNodes[math.min(j, _codeControllers.length - 1)]);
  }

  KeyEventResult _onKeyEventHandler(int index, KeyEvent event) {
    if (event is KeyUpEvent) {
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
        width: 32.0,
        child: _ParentCodeInputTextField(
          controller: _codeControllers[i],
          focusNode: _codeFocusNodes[i],
          isEnabled: widget.isEnabled,
          isOnError: widget.errorMessage != null || widget.isOnError,
          inputAction: i == _codeControllers.length - 1
              ? TextInputAction.send
              : TextInputAction.next,
          onTap: _onTapHandler,
          onChanged: (value) => _onChangedHandler(i, value),
          onEditingComplete: () => _onEditingCompleteHandler(i),
          onFieldSubmitted: (value) => _onFieldSubmittedHandler(i),
          onOverflow: (value) => _onOverflowHandler(i, value),
          onKeyEvent: (event) => _onKeyEventHandler(i, event),
        ),
      ));

      if (i + 1 < _codeControllers.length) {
        inputFieldElements.add(const SizedBox(
          width: 8.0,
        ));
      }
    }

    return inputFieldElements;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _onTapHandler,
          child: Container(
            color: ColorConstants.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildInputFieldBody(),
            ),
          ),
        ),
        if (widget.errorMessage != null)
          SizedBox(
            height: 40.0,
            child: Center(
              child: CustomText(
                text: widget.errorMessage!,
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

class _ParentCodeInputTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool isEnabled, isOnError;
  final TextInputAction inputAction;
  final Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final Function(String)? onFieldSubmitted;
  final Function(bool)? onFocusChange;
  final Function(String)? onOverflow;
  final Function(KeyEvent)? onKeyEvent;

  const _ParentCodeInputTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.isEnabled = true,
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
  State<_ParentCodeInputTextField> createState() => _ParentCodeInputTextFieldState();
}

class _ParentCodeInputTextFieldState extends State<_ParentCodeInputTextField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

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
    setState(() {
      _isFocused = value;
    });

    if (widget.onFocusChange != null) {
      widget.onFocusChange!(value);
    }
  }

  void _onTapHandler() {
    if (widget.onTap != null) {
      widget.onTap!();
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

  TextStyle _getLabelTextStyle() {
    final defaultTextStyle = Theme.of(context).textTheme.headlineMedium!.copyWith(
      decorationThickness: 0.0,
    );

    return defaultTextStyle;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Focus(
          onFocusChange: _onFocusChangeHandler,
          onKeyEvent: _onKeyEventHandler,
          child: GestureDetector(
            onTap: widget.isEnabled ? null : _onTapHandler,
            child: TextFormField(
              controller: widget.controller,
              enabled: widget.isEnabled,
              focusNode: _focusNode,
              keyboardType: TextInputType.visiblePassword,
              textAlign: TextAlign.center,
              textInputAction: widget.inputAction,
              style: _getLabelTextStyle(),
              decoration: InputDecoration(
                border: Theme.of(context).inputDecorationTheme.border?.copyWith(
                  borderSide: Theme.of(context).inputDecorationTheme.border?.borderSide.copyWith(
                    color: widget.isEnabled ? null : ColorConstants.textFieldDisabledBG(),
                  ),
                ),
                enabledBorder: widget.isOnError
                    ? Theme.of(context).inputDecorationTheme.errorBorder
                    : null,
                focusedBorder: widget.isOnError
                    ? Theme.of(context).inputDecorationTheme.errorBorder
                    : null,
                disabledBorder: Theme.of(context).inputDecorationTheme.disabledBorder?.copyWith(
                  borderSide: Theme.of(context).inputDecorationTheme.disabledBorder?.borderSide.copyWith(
                    color: ColorConstants.textFieldDisabledBG(),
                  ),
                ),
                fillColor: widget.isEnabled
                    ? ColorConstants.textFieldBG()
                    : ColorConstants.textFieldDisabledBG(),
                contentPadding: const EdgeInsets.only(
                  left: 3.0,
                ),
              ),
              /// Don't ruin formatter order
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
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
              maxLines: 1,
              onChanged: _onChangedHandler,
              onEditingComplete: widget.onEditingComplete,
              onTap: widget.onTap,
              onFieldSubmitted: widget.onFieldSubmitted,
            ),
          ),
        ),
        if (widget.controller.value.text.isEmpty && !_isFocused)
          Positioned.fill(
            left: Theme.of(context).inputDecorationTheme.border?.borderSide.width,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  _focusNode.requestFocus();
                },
                child: CustomText(
                  text: '-',
                  style: _getLabelTextStyle(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
