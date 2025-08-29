import 'package:feed_app/app/export.dart';

class ImageSourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const ImageSourceButton({super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Colors.blue;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.s12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.s16,
          horizontal: AppSizes.s12,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: buttonColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(AppSizes.s12),
          color: buttonColor.withOpacity(0.1),
        ),
        child: Column(
          children: [
            Icon(icon, color: buttonColor, size: AppSizes.s32),
            AppSizes.vGap8,
            CustomText(
              label,
              style: TextStyle(color: buttonColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}