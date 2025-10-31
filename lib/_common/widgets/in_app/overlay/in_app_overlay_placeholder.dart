part of 'in_app_overlay_provider.dart';

class InAppOverlayPlaceholder extends StatelessWidget {
  final String? text;

  const InAppOverlayPlaceholder({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: ColorConstants.overlayBG(),
        border: Border.all(color: ColorConstants.overlayBorder()),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomProgressIndicator.simple(size: 24.0),
          SizedBox(
            width: 12.0,
          ),
          Flexible(
            child: CustomText(
              text: text ?? 'button.processing'.tr(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w400,
                color: ColorConstants.textGrey(),
              ),
              maxLines: 1,
              isVerticalCentered: false,
            ),
          ),
        ],
      ),
    );
  }
}
