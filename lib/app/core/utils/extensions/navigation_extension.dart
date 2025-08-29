import 'package:feed_app/app/export.dart';

extension NavExtension on BuildContext {

  void pushRoute(String path, {Object? extra}) {
    push(path, extra: extra);
  }

  void goRoute(String path, {Object? extra}) {
    go(path, extra: extra);
  }

  void pushReplacementRoute(String path, {Object? extra}) {
    pushReplacement(path, extra: extra);
  }

  void popRoute<T extends Object?>([T? result]) {
    pop(result);
  }
}
