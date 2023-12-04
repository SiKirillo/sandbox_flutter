import 'package:flutter/material.dart';

import '../common/services/gifs_builder_service.dart';

class ImageConstants {
  static void precacheAssets(BuildContext context) {
    precacheImage(Image.asset(ImageConstants.imPartyCat).image, context);
    GifsBuilderService.precacheGIF(Image.asset(ImageConstants.igPartyCat).image, frameRate: 10);
  }

  /// Service icons
  static const icClose = 'assets/icons/ic_close.png';
  static const icProgress = 'assets/icons/ic_progress.png';
  static const icWeather = 'assets/icons/ic_weather.png';

  /// Custom images
  static const imFunnyCat = 'assets/images/im_funny_cat.png';
  static const imPartyCat = 'assets/images/im_party_cat.png';
  static const imLoveCat = 'assets/images/im_love_cat.png';

  /// Custom GIF-s
  static const igLunchCat = 'assets/gifs/ig_lunch_cat.gif';
  static const igPartyCat = 'assets/gifs/ig_party_cat.gif';
  static const igRandomCat = 'assets/gifs/ig_random_cat.gif';
  static const igSleepCat = 'assets/gifs/ig_sleep_cat.gif';
}
