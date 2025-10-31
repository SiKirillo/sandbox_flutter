import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_darwin/types/auth_messages_ios.dart';
import 'package:location/location.dart' as location;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sandbox_flutter/_common/services/logger/logger_service.dart';
import 'package:sandbox_flutter/_common/widgets/in_app/dialogs/in_app_dialogs_provider.dart';
import 'package:sandbox_flutter/_common/widgets/in_app/notifications/in_app_notification_provider.dart';
import 'package:sandbox_flutter/_common/widgets/in_app/overlay/in_app_overlay_provider.dart';
import 'package:sandbox_flutter/_common/widgets/in_app/slider/in_app_slider_provider.dart';
import 'package:sandbox_flutter/_common/widgets/in_app/toast/in_app_toast_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sms_autofill/sms_autofill.dart' as sms;

import '../features/camera/camera.dart';

part '../features/screen_builder.dart';
part 'injection_container.dart';

/// Constants
part '../constants/colors.dart';
part '../constants/environment.dart';
part '../constants/failures.dart';
part '../constants/images.dart';
part '../constants/languages.dart';
part '../constants/other.dart';
part '../constants/router.dart';
part '../constants/sizes.dart';
part '../constants/themes.dart';

/// _Features
part '_features/data/datasources/app_preferences_storage.dart';
part '_features/domain/bloc/app_bloc.dart';
part '_features/domain/bloc/app_events.dart';
part '_features/domain/bloc/app_state.dart';
part '_features/domain/repository/app_repository.dart';
part '_features/presentation/screens/splash_screen.dart';

/// Entities
part 'entities/bloc_entities.dart';
part 'entities/failure_entity.dart';
part 'entities/remote_datasource_entity.dart';
part 'entities/secure_datasource_entity.dart';
part 'entities/shared_preferences_datasource_entity.dart';

/// Extensions
part 'extensions/date_times.dart';
part 'extensions/iterables.dart';
part 'extensions/numbers.dart';
part 'extensions/phone_numbers.dart';
part 'extensions/strings.dart';

/// Providers
part 'providers/network_provider.dart';
part 'providers/theme_provider.dart';

/// Services
part 'services/biometric_service.dart';
part 'services/device_service.dart';
part 'services/locale_service.dart';
part 'services/location_service.dart';
part 'services/permission_service.dart';

/// Widgets
part 'widgets/animations/animated_switcher.dart';
part 'widgets/animations/cross_fade_animation.dart';

part 'widgets/buttons/small_button.dart';
part 'widgets/buttons/button.dart';
part 'widgets/buttons/hyperlink_button.dart';
part 'widgets/buttons/icon_button.dart';
part 'widgets/buttons/outline_button.dart';
part 'widgets/buttons/tab_button.dart';
part 'widgets/buttons/text_button.dart';

part 'widgets/dialogs/action_dialog.dart';

part 'widgets/in_app/dev_build_version.dart';

part 'widgets/indicators/progress_indicator.dart';
part 'widgets/indicators/pull_to_refresh_indicator.dart';
part 'widgets/indicators/sliver_refresh_indicator.dart';

part 'widgets/input_fields/otp_code_input_field.dart';
part 'widgets/input_fields/input_formatters.dart';
part 'widgets/input_fields/input_validators.dart';
part 'widgets/input_fields/search_input_field.dart';
part 'widgets/input_fields/text_input_field.dart';

part 'widgets/wrappers/content_wrapper.dart';
part 'widgets/wrappers/dialog_wrapper.dart';
part 'widgets/wrappers/opacity_wrapper.dart';
part 'widgets/wrappers/responsive_wrapper.dart';
part 'widgets/wrappers/scaffold_wrapper.dart';
part 'widgets/wrappers/scrollable_wrapper.dart';

part 'widgets/app_bar.dart';
part 'widgets/appbar_indicator.dart';
part 'widgets/check_box.dart';
part 'widgets/divider.dart';
part 'widgets/dropdown_menu.dart';
part 'widgets/expansion_tile.dart';
part 'widgets/gifs_builder.dart';
part 'widgets/list_view_animated_builder.dart';
part 'widgets/list_tile.dart';
part 'widgets/list_view_builder.dart';
part 'widgets/list_view_grouped_builder.dart';
part 'widgets/navigation_bar.dart';
part 'widgets/network_image.dart';
part 'widgets/page_indicator.dart';
part 'widgets/popup_menu.dart';
part 'widgets/progress_bar.dart';
part 'widgets/scroll_opacity_gradient.dart';
part 'widgets/scrollbar.dart';
part 'widgets/slider.dart';
part 'widgets/swipeable_page_route.dart';
part 'widgets/switch.dart';
part 'widgets/texts.dart';
