import 'package:flutter/material.dart';

import '../../../constants/sizes.dart';

class SandboxIconButton extends StatelessWidget {
  final dynamic icon;
  final VoidCallback onCallback;
  final double size;
  final Color? color;

  const SandboxIconButton({
    Key? key,
    required this.icon,
    required this.onCallback,
    this.size = SizeConstants.defaultIconSize,
    this.color,
  })  : assert(icon is String || icon is Icon || icon is Image),
        assert(size >= 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        maxHeight: size,
        maxWidth: size,
      ),
      icon: icon is Image || icon is Icon ? icon : Image.asset(icon),
      color: color ?? Theme.of(context).iconTheme.color,
      splashRadius: size,
      onPressed: onCallback,
    );
  }
}
