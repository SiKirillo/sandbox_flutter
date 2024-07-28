import 'package:flutter/material.dart';

import '../../../common/widgets/texts.dart';
import '../../../constants/colors.dart';
import '../../../constants/images.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62.0,
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 12.0,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: ColorConstants.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: CustomText(
                    text: 'NEW YORK, NY',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      height: 15.0 / 12.0,
                    ),
                  ),
                ),
                Flexible(
                  child: CustomText(
                    text: '23°C, Sun Showers',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      height: 18.0 / 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox.square(
            dimension: 46.0,
            child: Image.asset(ImageConstants.icWeather),
          ),
        ],
      ),
    );
  }
}
