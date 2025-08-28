import 'package:feed_app/app/export.dart';

extension TextExtensions on TextStyle {
  TextStyle get thin => copyWith(fontWeight: FontWeight.w100);

  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);

  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);


  TextStyle size(double value) => copyWith(fontSize: value);

  TextStyle color(Color value) => copyWith(color: value);
}
