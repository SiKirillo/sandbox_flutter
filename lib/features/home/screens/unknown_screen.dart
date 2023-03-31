import 'package:flutter/material.dart';

import '../../../common/widgets/texts.dart';
import '../../../common/widgets/wrappers/scaffold_wrapper.dart';

class UnknownScreen extends StatelessWidget {
  static const routeName = '/unknown';
  static const routeTabNumber = 2;
  static const routeTabName = 'Unknown';

  const UnknownScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ScaffoldWrapper(
      child: Center(
        child: SandboxText(
          text: UnknownScreen.routeTabName,
        ),
      ),
    );
  }
}
