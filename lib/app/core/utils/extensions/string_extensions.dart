extension StringExtensions on String{
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');
}