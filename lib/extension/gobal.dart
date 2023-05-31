import 'package:flutter/material.dart';

late double screenHeight;
late double screenWidth;
void setScreenHeight(BuildContext context) {
  screenHeight = MediaQuery.of(context).size.height;
}

void setscreenWidth(BuildContext context) {
  screenWidth = MediaQuery.of(context).size.width;
}
