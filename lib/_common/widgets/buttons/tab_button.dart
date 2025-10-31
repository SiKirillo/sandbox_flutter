part of '../../common.dart';

class CustomTabButton extends StatelessWidget {
  final String label;
  final int? length;
  final bool isSelected;
  final Color? buttonColorDisable;
  final Color? buttonTextColorDisable;
  final VoidCallback onTap;

  const CustomTabButton({
    super.key,
    required this.label,
    this.length,
    this.isSelected = false,
    this.buttonColorDisable,
    this.buttonTextColorDisable,
    required this.onTap,
  });

  Color get _buttonColor => isSelected ? ColorConstants.tabButtonActive() : buttonColorDisable ?? ColorConstants.tabButtonDisable();
  Color get _buttonLengthColor => isSelected ? ColorConstants.tabButtonLengthActive() : ColorConstants.tabButtonLengthDisable();
  Color get _buttonTextColor => isSelected ? ColorConstants.textWhite() : buttonTextColorDisable ?? ColorConstants.textGrey();

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      content: Row(
        children: [
          CustomText(
            text: label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 16.0 / 13.0,
              color: _buttonTextColor,
            ),
            maxLines: 1,
          ),
          if (length != null) ...[
            SizedBox(width: 6.0),
            Container(
              constraints: BoxConstraints(
                minWidth: 18.0,
              ),
              padding: EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 4.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                color: Colors.white.withValues(alpha: 0.2),
              ),
              child: Center(
                child: CustomText(
                  text: length!.toFormattedWithDots(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _buttonTextColor,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: onTap,
      options: CustomButtonOptions(
        height: 32.0,
        padding: EdgeInsets.symmetric(
          vertical: 6.0,
          horizontal: 8.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: _buttonColor,
      ),
      isExpanded: false,
    );
  }
}
