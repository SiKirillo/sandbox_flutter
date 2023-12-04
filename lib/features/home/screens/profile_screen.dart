import 'package:flutter/material.dart';

import '../../../common/widgets/indicators/sliver_refresh_indicator.dart';
import '../../../common/widgets/wrappers/content_wrapper.dart';
import '../../../common/widgets/wrappers/scaffold_wrapper.dart';
import '../../../common/widgets/wrappers/scrollable_wrapper.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  static const routeTabNumber = 2;
  static const routeTabName = 'Profile';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _controller = ScrollController();
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

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      isDisabled: _isRequestInProgress,
      child: ContentWrapper(
        padding: ContentWrapper.defaultPadding.copyWith(
          top: 0.0,
          bottom: 0.0,
        ),
        child: ScrollableWrapper(
          controller: _controller,
          sliverRefreshIndicator: SliverRefreshIndicator(
            onRefresh: _onRefreshHandler,
          ),
          isAlwaysScrollable: true,
          child: const Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
