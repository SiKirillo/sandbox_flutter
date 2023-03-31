import 'package:flutter/material.dart';

import '../../../common/widgets/texts.dart';
import '../../../common/widgets/wrappers/scaffold_wrapper.dart';

class RandomScreen extends StatelessWidget {
  static const routeName = '/random';
  static const routeTabNumber = 1;
  static const routeTabName = 'Random';

  const RandomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ScaffoldWrapper(
      child: Center(
        child: SandboxText(
          text: RandomScreen.routeTabName,
        ),
      ),
    );
  }
}
