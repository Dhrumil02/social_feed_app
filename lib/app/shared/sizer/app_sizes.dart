import 'package:feed_app/app/export.dart';

class AppSizes {
  static const double s1 = 1;
  static const double s1p5 = 1.5;
  static const double s2 = 2;
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s11 = 11;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s22 = 22;
  static const double s24 = 24;
  static const double s28 = 28;
  static const double s32 = 32;
  static const double s36 = 36;
  static const double s40 = 40;
  static const double s44 = 44;
  static const double s45 = 45;
  static const double s48 = 48;
  static const double s57 = 57;

  static const HGap hGap4 = HGap(s4);
  static const HGap hGap8 = HGap(s8);
  static const HGap hGap12 = HGap(s12);
  static const HGap hGap16 = HGap(s16);

  static const VGap vGap4 = VGap(s4);
  static const VGap vGap8 = VGap(s8);
  static const VGap vGap12 = VGap(s12);
  static const VGap vGap16 = VGap(s16);
}

class HGap extends StatelessWidget {
  final double size;

  const HGap(this.size, {super.key});

  @override
  Widget build(BuildContext context) => SizedBox(width: size);
}

class VGap extends StatelessWidget {
  final double size;

  const VGap(this.size, {super.key});

  @override
  Widget build(BuildContext context) => SizedBox(height: size);
}
