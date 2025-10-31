import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:path_provider/path_provider.dart';

import '../../_common/common.dart';
import '../../_common/services/logger/logger_service.dart';
import '../../_common/widgets/in_app/overlay/in_app_overlay_provider.dart';

part 'domain/bloc/camera_bloc.dart';
part 'domain/bloc/camera_events.dart';
part 'domain/bloc/camera_state.dart';
part 'domain/entities/camera_preview_entity.dart';
part 'domain/entities/camera_result_entity.dart';
part 'domain/entities/camera_settings_options.dart';
part 'domain/enums/camera_type.dart';
part 'domain/repository/camera_repository.dart';

part 'presentation/screens/camera_picture_preview_screen.dart';
part 'presentation/screens/camera_screen.dart';
part 'presentation/widgets/picture_preview_card.dart';