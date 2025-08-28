import 'package:feed_app/app/export.dart';

extension StringExtensions on String{
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  
}