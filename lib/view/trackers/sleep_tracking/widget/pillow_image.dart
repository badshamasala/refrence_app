import 'package:flutter/material.dart';

import '../../../shared/shared.dart';

class PillowImage extends StatelessWidget {
  final String icon;
  final bool active;
  final double? width;
  final double? height;
  final BoxFit fit;

  const PillowImage(
      {Key? key,
      required this.icon,
      required this.active,
      this.width,
      this.height,
      required this.fit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          active
              ? Images.activePillowSleepTrackerImage
              : Images.inActivePillowSleepTrackerImage,
          width: width,
          height: height,
          fit: fit,
        ),
        Image.asset(
          icon,
          width: width,
          height: height,
          fit: fit,
        )
      ],
    );
  }
}
