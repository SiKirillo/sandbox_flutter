part of '../common/common.dart';

class StyleConstants {
  static const defaultAnimationDuration = Duration(milliseconds: 300);
  static const defaultDelayDuration = Duration(milliseconds: 500);
  static const defaultUsecaseDelayDuration = Duration(milliseconds: 50);

  static const defaultPhysics = BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  static const bouncingScrollPhysics = BouncingScrollPhysics();
  static const disableScrollPhysics = NeverScrollableScrollPhysics();
}