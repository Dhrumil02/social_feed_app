import 'package:feed_app/app/export.dart';

extension WidgetExtensions on Widget {
  Widget padAll(double padding) {
    return Padding(padding: Spacing.all(padding), child: this);
  }

  Widget get center => Center(child: this);

  Widget get expanded => Expanded(child: this);

  Widget flexible([int flex = 1]) => Flexible(flex: flex, child: this);

  Widget onTap(VoidCallback? onTap) {
    return GestureDetector(onTap: onTap, child: this);
  }
}
