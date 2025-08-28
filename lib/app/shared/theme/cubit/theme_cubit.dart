import 'package:feed_app/app/export.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(AppTheme.light);

  void updateTheme(Color color, bool isDarkMode) {
    emit(
      ThemeData(
        primaryColor: color,
        primarySwatch: AppColors.createMaterialColor(color),
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );
  }

  void toggleTheme(bool isDarkMode) {
    emit(isDarkMode ? AppTheme.dark : AppTheme.light);
  }
}
