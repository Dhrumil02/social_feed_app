import 'package:feed_app/app/export.dart';

class AppColors {
  static const Color seed = Color(0xFF45B828);

  static const Color primary = Color(0xFF45B828);
  static const Color primaryDark = Color(0xFF2E7D23);
  static const Color primaryLight = Color(0xFF6DCE55);

  static const Color secondary = Color(0xFF2B5E1A);
  static const Color accent = Color(0xFF88E063);

  static const Color backgroundLight = Color(0xFFF9FAF8);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);

  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  static Color textColorForBackground(Color backgroundColor) {
    if (ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark) {
      return Colors.white;
    }

    return Colors.black;
  }
}
