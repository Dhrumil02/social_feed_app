import 'package:feed_app/app/export.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppHelper {
  static showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.backgroundDark,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}