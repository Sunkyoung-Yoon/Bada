import 'package:flutter/material.dart';

class UIhelper {
  static double deviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double scaleWidth(BuildContext context) {
    const designGuideWidth = 411.4;
    final screenWidth = deviceWidth(context);
    return (screenWidth / designGuideWidth);
  }

  static double deviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double scaleHeight(BuildContext context) {
    const designGuideHeight = 843.4;
    final screenHeight = deviceHeight(context);
    return (screenHeight / designGuideHeight);
  }
}
