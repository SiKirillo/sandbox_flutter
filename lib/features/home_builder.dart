import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../common/common.dart';

class HomeBuilder extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeBuilder({
    super.key,
    required this.navigationShell,
  });

  void _onSelectHandler(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (SizeConstants.isTabletDevice(context: context)) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: navigationShell,
            ),
            Positioned(
              top: 16.0,
              left: math.max(20.0, ResponsiveWrapper.responsivePadding(context) - SizeConstants.defaultNavigationBarSize),
              child: CustomNavigationRail(
                items: [
                  NavigationBarData(
                    label: 'contacts.navigation_bar'.tr(),
                    icon: 'ImageConstants.icNavigationContacts',
                  ),
                  NavigationBarData(
                    label: 'chats.navigation_bar'.tr(),
                    icon: 'ImageConstants.icNavigationChats',
                  ),
                  NavigationBarData(
                    label: 'settings.navigation_bar'.tr(),
                    icon: 'ImageConstants.icNavigationSettings',
                  ),
                ],
                onSelect: _onSelectHandler,
                currentIndex: navigationShell.currentIndex,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: CustomNavigationBar(
        items: [
          NavigationBarData(
            label: 'contacts.navigation_bar'.tr(),
            icon: 'ImageConstants.icNavigationContacts',
          ),
          NavigationBarData(
            label: 'chats.navigation_bar'.tr(),
            icon: 'ImageConstants.icNavigationChats',
          ),
          NavigationBarData(
            label: 'settings.navigation_bar'.tr(),
            icon: 'ImageConstants.icNavigationSettings',
          ),
        ],
        onSelect: _onSelectHandler,
        currentIndex: navigationShell.currentIndex,
      ),
    );
  }
}
