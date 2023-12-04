import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/models/app_settings_model.dart';
import '../../../common/usecases/core_update_settings.dart';
import '../../../common/providers/theme_provider.dart';
import '../../../common/widgets/app_bar.dart';
import '../../../common/widgets/indicators/sliver_refresh_indicator.dart';
import '../../../common/widgets/list_tile.dart';
import '../../../common/widgets/switch.dart';
import '../../../common/widgets/texts.dart';
import '../../../common/widgets/wrappers/content_wrapper.dart';
import '../../../common/widgets/wrappers/scaffold_wrapper.dart';
import '../../../common/widgets/wrappers/scrollable_wrapper.dart';
import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../injection_container.dart';
import '../../authentication/domain/bloc/auth_bloc.dart';
import '../widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  static const routeTabNumber = 0;
  static const routeTabName = 'Home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isRequestInProgress = false;

  Future<void> _onRefreshHandler() async {
    if (_isRequestInProgress) {
      return;
    }

    setState(() {
      _isRequestInProgress = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRequestInProgress = false;
    });
  }

  CustomSliverAppBar _buildSliverAppBar() {
    return const CustomSliverAppBar(
      content: 'Home Example',
      flexibleSize: 90.0,
      flexibleContent: FlexibleSpaceBar(
        expandedTitleScale: 1.0,
        titlePadding: ContentWrapper.defaultPadding,
        title: SingleChildScrollView(
          reverse: true,
          physics: NeverScrollableScrollPhysics(),
          child: WeatherCard(),
        ),
      ),
      withBackButton: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      isDisabled: _isRequestInProgress,
      child: ScrollableWrapper(
        sliverAppBar: _buildSliverAppBar(),
        sliverRefreshIndicator: SliverRefreshIndicator(
          onRefresh: _onRefreshHandler,
        ),
        padding: ScrollableWrapper.defaultPadding.copyWith(
          top: ScrollableWrapper.defaultPadding.top + MediaQuery.of(context).viewPadding.top,
        ),
        isAlwaysScrollable: true,
        child: ContentWrapper(
          padding: ContentWrapper.defaultPadding.copyWith(
            top: 0.0,
            bottom: 0.0,
          ),
          withSafeAreaResize: false,
          child: Column(
            children: [
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (prev, current) {
                  return prev.userData != current.userData;
                },
                builder: (_, state) {
                  return CustomListTile(
                    title: 'Hello User!',
                    subtitle: state.userData?.email ?? 'example@gmail.com',
                    leading: Container(
                      height: 40.0,
                      width: 40.0,
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        shape: BoxShape.circle,
                        color: ColorConstants.transparent,
                      ),
                      child: Image.asset(ImageConstants.imFunnyCat),
                    ),
                    titleStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      height: 1.0,
                    ),
                    subtitleStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    descriptionIndent: 6.0,
                    leadingIndent: 12.0,
                  );
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              Row(
                children: [
                  const CustomText(
                    text: 'Theme',
                  ),
                  CustomSwitch(
                    value: context.watch<ThemeProvider>().mode == ThemeMode.dark,
                    onCallback: (value) {
                      locator<CoreUpdateSettings>().call(AppSettingsData(
                        themeMode: value ? ThemeMode.dark : ThemeMode.light,
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
