import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandbox_flutter/common/bloc/core_bloc.dart';
import 'package:sandbox_flutter/common/widgets/switch.dart';
import 'package:sandbox_flutter/common/widgets/texts.dart';
import 'package:sandbox_flutter/common/widgets/wrappers/content_wrapper.dart';
import 'package:sandbox_flutter/common/widgets/wrappers/scrollable_wrapper.dart';
import 'package:sandbox_flutter/injection_container.dart';

import '../../../common/usecases/core_update_settings.dart';
import '../../../common/providers/theme_provider.dart';
import '../../../common/widgets/wrappers/scaffold_wrapper.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  static const routeTabNumber = 0;
  static const routeTabName = 'Home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      child: ContentWrapper(
        padding: ContentWrapper.defaultPadding.copyWith(
          top: 0.0,
          bottom: 0.0,
        ),
        child: ScrollableWrapper(
          child: Column(
            children: [
              Row(
                children: [
                  const SandboxText(
                    text: 'Theme',
                  ),
                  SandboxSwitch(
                    value: context.watch<ThemeProvider>().type == ThemeStyleType.dark,
                    onCallback: (value) {
                      locator<CoreUpdateSettings>().call(CoreSettingsData(
                        themeType: value ? ThemeStyleType.dark : ThemeStyleType.light,
                      ));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
