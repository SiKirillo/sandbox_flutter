import 'package:flutter/cupertino.dart';

import '../../constants/colors.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onCallback;
  final Size size;

  const CustomSwitch({
    Key? key,
    required this.value,
    required this.onCallback,
    this.size = const Size(41.0, 25.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: FittedBox(
        fit: BoxFit.cover,
        child: CupertinoSwitch(
          activeColor: ColorConstants.transparent,
          trackColor: ColorConstants.transparent,
          thumbColor: ColorConstants.transparent,
          value: value,
          onChanged: onCallback,
        ),
      ),
    );
  }
}
