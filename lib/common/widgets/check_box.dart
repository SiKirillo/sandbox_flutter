import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import 'progress_indicators/progress_indicator.dart';

class SandboxCheckBox extends StatelessWidget {
  final bool isChecked;
  final Function(bool) onCallback;
  final double size;
  final bool isProcessing;

  const SandboxCheckBox({
    Key? key,
    required this.isChecked,
    required this.onCallback,
    this.size = 20.0,
    this.isProcessing = false,
  })  : assert(size >= 0),
        super(key: key);

  void _onPressedHandler() {
    if (!isProcessing) {
      onCallback(!isChecked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressedHandler,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: !isProcessing && isChecked
              ? null
              : Border.all(color: ColorConstants.light.black500),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isProcessing
              ? const SandboxProgressIndicator()
              : SizedBox.square(
                  dimension: size,
                  child: const Icon(Icons.check),
                ),
        ),
      ),
    );
  }
}
