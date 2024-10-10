import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'dart:math' as math;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart' as email;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_darwin/types/auth_messages_ios.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../features/authentication/domain/bloc/auth_bloc.dart';
import '../features/home_builder.dart';
import '../features/welcome_screen.dart';
import 'injection_container.dart';

part '../constants/colors.dart';
part '../constants/environment.dart';
part '../constants/failures.dart';
part '../constants/images.dart';
part '../constants/router.dart';
part '../constants/sizes.dart';
part '../constants/style.dart';
part '../constants/themes.dart';

part 'datasources/app_preferences_storage.dart';

part 'extensions/date_times.dart';
part 'extensions/iterables.dart';
part 'extensions/phone_numbers.dart';
part 'extensions/strings.dart';

part 'models/service/failure_model.dart';
part 'models/service/remote_datasource_model.dart';
part 'models/service/secure_datasource.model.dart';
part 'models/service/shared_preferences_datasource_model.dart';
part 'models/service/usecase_model.dart';

part 'providers/theme_provider.dart';

part 'services/biometric_service.dart';
part 'services/crypto_service.dart';
part 'services/device_service.dart';
part 'services/firebase_service.dart';
part 'services/gifs_builder_service.dart';
part 'services/logger_service.dart';
part 'services/permission_service.dart';
part 'services/push_notification_service.dart';
part 'services/supabase_service.dart';

part 'usecases/app_init.dart';

part 'utilities/dialogs_util.dart';
part 'utilities/loading_overlay_util.dart';

part 'widgets/animations/animated_switcher.dart';
part 'widgets/animations/auto_scroll.dart';
part 'widgets/animations/cross_fade_animation.dart';
part 'widgets/animations/slide_animation.dart';

part 'widgets/buttons/icon_button.dart';
part 'widgets/buttons/text_and_icon_button.dart';
part 'widgets/buttons/text_button.dart';
part 'widgets/dialogs/action_dialog.dart';
part 'widgets/dialogs/progress_dialog.dart';
part 'widgets/dialogs/settings_dialog.dart';
part 'widgets/dialogs/success_dialog.dart';
part 'widgets/dialogs/warning_dialog.dart';
part 'widgets/in_app_elements/dev_build_version.dart';
part 'widgets/indicators/progress_indicator.dart';
part 'widgets/indicators/pull_to_refresh_indicator.dart';
part 'widgets/indicators/sliver_refresh_indicator.dart';
part 'widgets/input_fields/confirmation_code_input_field.dart';
part 'widgets/input_fields/input_formatters.dart';
part 'widgets/input_fields/input_validators.dart';
part 'widgets/input_fields/text_input_field.dart';
part 'widgets/wrappers/content_wrapper.dart';
part 'widgets/wrappers/dialog_wrapper.dart';
part 'widgets/wrappers/opacity_wrapper.dart';
part 'widgets/wrappers/responsive_wrapper.dart';
part 'widgets/wrappers/scaffold_wrapper.dart';
part 'widgets/wrappers/scrollable_wrapper.dart';
part 'widgets/app_bar.dart';
part 'widgets/popup_card.dart';
part 'widgets/check_box.dart';
part 'widgets/dash_navigator.dart';
part 'widgets/divider.dart';
part 'widgets/list_tile.dart';
part 'widgets/list_view_builder.dart';
part 'widgets/list_view_grouped_builder.dart';
part 'widgets/navigation_bar.dart';
part 'widgets/navigation_rail.dart';
part 'widgets/popup_menu.dart';
part 'widgets/progress_bar.dart';
part 'widgets/switch.dart';
part 'widgets/tab_bar.dart';
part 'widgets/texts.dart';