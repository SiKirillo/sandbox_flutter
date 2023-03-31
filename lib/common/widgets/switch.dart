import 'package:flutter/cupertino.dart';

import '../../constants/colors.dart';

class SandboxSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onCallback;
  final Size size;

  const SandboxSwitch({
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
          activeColor: ColorConstants.light.green500,
          trackColor: const Color(0xFF787880).withOpacity(0.32),
          thumbColor: ColorConstants.light.white500,
          value: value,
          onChanged: onCallback,
        ),
      ),
    );
  }
}
