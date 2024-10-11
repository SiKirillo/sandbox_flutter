part of '../common.dart';

class CustomCheckBox extends StatelessWidget {
  final Function(bool) onTap;
  final bool isTapped;
  final double size;
  final bool isProcessing;

  const CustomCheckBox({
    super.key,
    required this.onTap,
    required this.isTapped,
    this.size = 20.0,
    this.isProcessing = false,
  }) : assert(size >= 0);

  void _onPressedHandler() {
    if (!isProcessing) {
      onTap(!isTapped);
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
          border: !isProcessing && isTapped
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
