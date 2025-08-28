import 'package:flutter/widgets.dart';

class Spacing {
  static EdgeInsets x(double value) =>
      EdgeInsets.symmetric(horizontal: value);

  static EdgeInsets y(double value) =>
      EdgeInsets.symmetric(vertical: value);

  static EdgeInsets all(double value) =>
      EdgeInsets.all(value);

  static EdgeInsets left(double value) => EdgeInsets.only(left: value);
  static EdgeInsets right(double value) => EdgeInsets.only(right: value);
  static EdgeInsets top(double value) => EdgeInsets.only(top: value);
  static EdgeInsets bottom(double value) => EdgeInsets.only(bottom: value);

  static EdgeInsets only({
    double left = 0,
    double right = 0,
    double top = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.only(left: left, right: right, top: top, bottom: bottom);
}

