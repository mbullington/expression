import 'package:flutter/cupertino.dart';
import 'package:pigment/pigment.dart';

const double highEmphasis = 0.87;
const double mediumEmphasis = 0.57;
const double lowEmphasis = 0.12;

class TColors {
  static final Color darker = Pigment.fromString("#11131f");
  static final Color red = Pigment.fromString("#F3313B");
  static final Color accent = Pigment.fromString("#D9C30F");
}

CupertinoThemeData getTheme() {
  return CupertinoThemeData(brightness: Brightness.dark, primaryColor: CupertinoColors.systemGrey);
}

TextStyle getTextStyle() {
  return TextStyle(
    color: CupertinoColors.white,
    // https://ivomynttinen.com/blog/ios-design-guidelines#iconography
    fontSize: 34,
    letterSpacing: -0.41,
    fontWeight: FontWeight.bold,
    fontFamily: "SFProRounded",
  );
}

TextStyle getResultTextStyle() {
  return getTextStyle().copyWith(
    fontSize: 46.0,
    fontWeight: FontWeight.w300,
  );
}
