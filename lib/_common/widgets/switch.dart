part of '../common.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onTap;
  final Size size;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onTap,
    this.size = const Size(32.0, 18.0),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: FittedBox(
        fit: BoxFit.cover,
        child: Switch(
          value: value,
          onChanged: onTap,
          activeColor: ColorConstants.switchActiveThumb(),
          activeTrackColor: ColorConstants.switchActiveBG(),
          inactiveThumbColor: ColorConstants.switchInactiveThumb(),
          inactiveTrackColor: ColorConstants.switchInactiveBG(),
          thumbIcon: WidgetStateProperty.all(Icon(null)),
          trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) {
              return ColorConstants.switchActiveBG();
            }

            return ColorConstants.switchInactiveBG();
          }),
          trackOutlineWidth: WidgetStateProperty.resolveWith<double?>((states) {
            return 0.0;
          }),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
