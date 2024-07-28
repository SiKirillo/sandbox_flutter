import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import 'indicators/progress_indicator.dart';

class CustomCheckBox extends StatelessWidget {
  final bool isChecked;
  final Function(bool) onCallback;
  final double size;
  final bool isProcessing;

  const CustomCheckBox({
    super.key,
    required this.isChecked,
    required this.onCallback,
    this.size = 20.0,
    this.isProcessing = false,
  })  : assert(size >= 0);

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
              : Border.all(color: ColorConstants.transparent),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isProcessing
              ? const CustomProgressIndicator()
              : SizedBox.square(
                  dimension: size,
                  child: const Icon(Icons.check),
                ),
        ),
      ),
    );
  }
}
