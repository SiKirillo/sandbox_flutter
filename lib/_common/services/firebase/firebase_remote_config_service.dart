part of 'firebase_core_service.dart';

class FirebaseRemoteConfigService {
  static late FirebaseRemoteConfig _remoteConfig;

  static Future<void> init(FlavorMode flavor, FirebaseApp app) async {
    LoggerService.logTrace('FirebaseRemoteConfigService -> init(flavor: $flavor)');
    _remoteConfig = FirebaseRemoteConfig.instanceFor(app: app);

    try {
      await Future.wait([
        _remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        )),
        _remoteConfig.ensureInitialized(),
        _remoteConfig.fetchAndActivate(),
        _remoteConfig.setDefaults(_getFlavorModeSettings(flavor)),
      ]);

      await _remoteConfig.fetchAndActivate();
    } on Exception catch (e) {
      LoggerService.logError('FirebaseRemoteConfigService -> init()', exception: e);
    }
  }

  static bool isFeatureEnabled(FirebaseRemoteFlag flag) {
    return _remoteConfig.getBool(flag.key);
  }

  static double getFlappyBirdParam(FirebaseRemoteFlag flag) {
    return _remoteConfig.getDouble(flag.key);
  }

  static Map<String, dynamic> _getFlavorModeSettings(FlavorMode flavor) {
    if (flavor == FlavorMode.prod) {
      return {
        FirebaseRemoteFlag.commonSelectLanguage.key: true,
        FirebaseRemoteFlag.sellerMiniGames.key: true,
        FirebaseRemoteFlag.gameFlappyBirdVelocityHard.key: 310,
        FirebaseRemoteFlag.gameFlappyBirdCloudsHeightHard.key: 70,
        FirebaseRemoteFlag.gameFlappyBirdSpeedHard.key: 200,
        FirebaseRemoteFlag.gameFlappyBirdGravityHard.key: -110,
        FirebaseRemoteFlag.gameFlappyBirdGroundHeightHard.key: 110,
        FirebaseRemoteFlag.gameFlappyBirdPipeIntervalHard.key: 2,
        FirebaseRemoteFlag.gameFlappyBirdVelocityEasy.key: 250,
        FirebaseRemoteFlag.gameFlappyBirdCloudsHeightEasy.key: 70,
        FirebaseRemoteFlag.gameFlappyBirdSpeedEasy.key: 180,
        FirebaseRemoteFlag.gameFlappyBirdGravityEasy.key: -130,
        FirebaseRemoteFlag.gameFlappyBirdGroundHeightEasy.key: 110,
        FirebaseRemoteFlag.gameFlappyBirdPipeIntervalEasy.key: 4,
      };
    }

    if (flavor == FlavorMode.staging) {
      return {
        FirebaseRemoteFlag.commonSelectLanguage.key: true,
        FirebaseRemoteFlag.sellerMiniGames.key: true,
        FirebaseRemoteFlag.gameFlappyBirdVelocityHard.key: 310,
        FirebaseRemoteFlag.gameFlappyBirdCloudsHeightHard.key: 70,
        FirebaseRemoteFlag.gameFlappyBirdSpeedHard.key: 200,
        FirebaseRemoteFlag.gameFlappyBirdGravityHard.key: -110,
        FirebaseRemoteFlag.gameFlappyBirdGroundHeightHard.key: 110,
        FirebaseRemoteFlag.gameFlappyBirdPipeIntervalHard.key: 2,
        FirebaseRemoteFlag.gameFlappyBirdVelocityEasy.key: 250,
        FirebaseRemoteFlag.gameFlappyBirdCloudsHeightEasy.key: 70,
        FirebaseRemoteFlag.gameFlappyBirdSpeedEasy.key: 180,
        FirebaseRemoteFlag.gameFlappyBirdGravityEasy.key: -130,
        FirebaseRemoteFlag.gameFlappyBirdGroundHeightEasy.key: 110,
        FirebaseRemoteFlag.gameFlappyBirdPipeIntervalEasy.key: 4,
      };
    }

    if (flavor == FlavorMode.stable) {
      return {
        FirebaseRemoteFlag.commonSelectLanguage.key: true,
        FirebaseRemoteFlag.sellerMiniGames.key: true,
        FirebaseRemoteFlag.gameFlappyBirdVelocityHard.key: 310,
        FirebaseRemoteFlag.gameFlappyBirdCloudsHeightHard.key: 70,
        FirebaseRemoteFlag.gameFlappyBirdSpeedHard.key: 200,
        FirebaseRemoteFlag.gameFlappyBirdGravityHard.key: -110,
        FirebaseRemoteFlag.gameFlappyBirdGroundHeightHard.key: 110,
        FirebaseRemoteFlag.gameFlappyBirdPipeIntervalHard.key: 2,
        FirebaseRemoteFlag.gameFlappyBirdVelocityEasy.key: 250,
        FirebaseRemoteFlag.gameFlappyBirdCloudsHeightEasy.key: 70,
        FirebaseRemoteFlag.gameFlappyBirdSpeedEasy.key: 180,
        FirebaseRemoteFlag.gameFlappyBirdGravityEasy.key: -130,
        FirebaseRemoteFlag.gameFlappyBirdGroundHeightEasy.key: 110,
        FirebaseRemoteFlag.gameFlappyBirdPipeIntervalEasy.key: 4,
      };
    }

    return {
      FirebaseRemoteFlag.commonSelectLanguage.key: true,
      FirebaseRemoteFlag.sellerMiniGames.key: true,
      FirebaseRemoteFlag.gameFlappyBirdVelocityHard.key: 310,
      FirebaseRemoteFlag.gameFlappyBirdCloudsHeightHard.key: 70,
      FirebaseRemoteFlag.gameFlappyBirdSpeedHard.key: 200,
      FirebaseRemoteFlag.gameFlappyBirdGravityHard.key: -110,
      FirebaseRemoteFlag.gameFlappyBirdGroundHeightHard.key: 110,
      FirebaseRemoteFlag.gameFlappyBirdPipeIntervalHard.key: 2,
      FirebaseRemoteFlag.gameFlappyBirdVelocityEasy.key: 250,
      FirebaseRemoteFlag.gameFlappyBirdCloudsHeightEasy.key: 70,
      FirebaseRemoteFlag.gameFlappyBirdSpeedEasy.key: 180,
      FirebaseRemoteFlag.gameFlappyBirdGravityEasy.key: -130,
      FirebaseRemoteFlag.gameFlappyBirdGroundHeightEasy.key: 110,
      FirebaseRemoteFlag.gameFlappyBirdPipeIntervalEasy.key: 4,
    };
  }
}

enum FirebaseRemoteFlag {
  /// Common
  commonSelectLanguage,
  /// Seller
  sellerMiniGames,
  /// Games - FlappyBird (Hard)
  gameFlappyBirdVelocityHard,
  gameFlappyBirdCloudsHeightHard,
  gameFlappyBirdSpeedHard,
  gameFlappyBirdGravityHard,
  gameFlappyBirdGroundHeightHard,
  gameFlappyBirdPipeIntervalHard,
  /// Games - FlappyBird (Easy)
  gameFlappyBirdVelocityEasy,
  gameFlappyBirdCloudsHeightEasy,
  gameFlappyBirdSpeedEasy,
  gameFlappyBirdGravityEasy,
  gameFlappyBirdGroundHeightEasy,
  gameFlappyBirdPipeIntervalEasy,
}

extension FirebaseRemoteFlagExtension on FirebaseRemoteFlag {
  String get key => switch (this) {
    FirebaseRemoteFlag.commonSelectLanguage => 'select_language_enabled',
    FirebaseRemoteFlag.sellerMiniGames => 'seller_mini_games_enabled',

    FirebaseRemoteFlag.gameFlappyBirdVelocityHard => 'seller_flappy_bird_hard_bird_velocity',
    FirebaseRemoteFlag.gameFlappyBirdCloudsHeightHard => 'seller_flappy_bird_hard_clouds_height',
    FirebaseRemoteFlag.gameFlappyBirdSpeedHard => 'seller_flappy_bird_hard_game_speed',
    FirebaseRemoteFlag.gameFlappyBirdGravityHard => 'seller_flappy_bird_hard_gravity',
    FirebaseRemoteFlag.gameFlappyBirdGroundHeightHard => 'seller_flappy_bird_hard_ground_height',
    FirebaseRemoteFlag.gameFlappyBirdPipeIntervalHard => 'seller_flappy_bird_hard_pipe_interval',

    FirebaseRemoteFlag.gameFlappyBirdVelocityEasy => 'seller_flappy_bird_easy_bird_velocity',
    FirebaseRemoteFlag.gameFlappyBirdCloudsHeightEasy => 'seller_flappy_bird_easy_clouds_height',
    FirebaseRemoteFlag.gameFlappyBirdSpeedEasy => 'seller_flappy_bird_easy_game_speed',
    FirebaseRemoteFlag.gameFlappyBirdGravityEasy => 'seller_flappy_bird_easy_gravity',
    FirebaseRemoteFlag.gameFlappyBirdGroundHeightEasy => 'seller_flappy_bird_easy_ground_height',
    FirebaseRemoteFlag.gameFlappyBirdPipeIntervalEasy => 'seller_flappy_bird_easy_pipe_interval',
  };
}
