part of '../common.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onTap;
  final bool isProcessing;
  final CustomCheckBoxOptions options;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onTap,
    this.isProcessing = false,
    this.options = const CustomCheckBoxOptions(),
  });

  void _onPressedHandler() {
    if (isProcessing) return;
    onTap(!value);
  }

  Widget _buildCheckbox() {
    if (isProcessing) {
      return Container(
        key: ValueKey('isProcessing'),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: options.borderColor ?? ColorConstants.checkboxBorder(),
            width: 2.0,
          ),
        ),
        child: Center(
          child: CustomProgressIndicator.simple(
            size: 10.0,
            color: ColorConstants.checkboxActive(),
          ),
        ),
      );
    }

    if (value) {
      return Container(
        key: ValueKey('isTapped'),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: options.tappedColor ?? ColorConstants.checkboxActive(),
        ),
        child: Center(
          child: CustomText(
            text: String.fromCharCode(Icons.check.codePoint),
            style: TextStyle(
              inherit: false,
              color: options.checkColor ?? ColorConstants.checkboxCheck(),
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
              fontFamily: Icons.check.fontFamily,
              package: Icons.check.fontPackage,
            ),
            isVerticalCentered: false,
          ),
        ),
      );
    }

    return Container(
      key: ValueKey('!isTapped'),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: options.borderColor ?? ColorConstants.checkboxBorder(),
          width: 2.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onPressedHandler,
      borderRadius: BorderRadius.circular(4.0),
      child: Ink(
        height: options.size,
        width: options.size,
        padding: options.padding,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: _buildCheckbox(),
        ),
      ),
    );
  }
}

class CustomCheckBoxOptions {
  final double size;
  final EdgeInsets padding;
  final Color? tappedColor;
  final Color? borderColor;
  final Color? checkColor;

  const CustomCheckBoxOptions({
    this.size = 24.0,
    this.padding = const EdgeInsets.all(2.0),
    this.tappedColor,
    this.borderColor,
    this.checkColor,
  });
}