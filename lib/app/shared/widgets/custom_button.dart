import 'package:feed_app/app/export.dart';
import 'package:feed_app/app/shared/widgets/custom_text.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final String? text;
  final Color backGroundColor;
  final double borderRadius;
  final Color borderColor;
  final Color fontColor;
  final FontWeight fontWeight;
  final double textSize;
  double? height;
  Widget? titleWidget;
  final Function() onPressed;
  bool isLoading;
  bool isEnabled = false;

  CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height,
    this.titleWidget,
    this.isLoading = false,
    required this.backGroundColor,
    required this.fontWeight,
    required this.borderColor,
    required this.fontColor,
    required this.isEnabled,
    required this.borderRadius,
    required this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: !isEnabled
          ? ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              minimumSize: WidgetStateProperty.all<Size>(
                Size.fromHeight(height ?? 40),
              ),
              backgroundColor: WidgetStateProperty.all<Color>(
                Colors.grey.shade400,
              ),
              elevation: WidgetStateProperty.all<double>(0),
            )
          : ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  side: BorderSide(color: borderColor),
                ),
              ),
              minimumSize: WidgetStateProperty.all<Size>(
                Size.fromHeight(height ?? 40),
              ),
              backgroundColor: WidgetStateProperty.all<Color>(backGroundColor),
              elevation: WidgetStateProperty.all<double>(0),
            ),
      onPressed: () {
        if (isEnabled) {
          onPressed();
        }
      },
      child: isLoading
          ? SizedBox(
              height: AppSizes.s20,
              width: AppSizes.s20,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : CustomText(
              text!,
              fontSize: textSize,
              fontWeight: fontWeight,
              color: fontColor,
            ),
    );
  }
}

class CustomImageButton extends StatelessWidget {
  final double? height, width;
  final Function()? onTap;
  final BoxFit? fit;
  final String image;

  const CustomImageButton({
    super.key,
    required this.image,
    required this.onTap,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: SvgPicture.asset(
        image,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
      ),
    );
  }
}

class CustomIconTextButton extends StatelessWidget {
  final String? text;
  final String? svgIcon;
  final bool iconRight;
  final Color backGroundColor;
  final Color borderColor;
  final Color fontColor;
  final FontWeight fontWeight;
  final double textSize;
  final double borderRadius;
  final double? height;
  final bool isEnabled;
  final bool isLoading;
  final Function() onPressed;

  const CustomIconTextButton({
    super.key,
    this.text,
    this.svgIcon,
    this.iconRight = false,
    required this.backGroundColor,
    required this.borderColor,
    required this.fontColor,
    required this.fontWeight,
    required this.textSize,
    required this.borderRadius,
    this.height,
    this.isEnabled = true,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: isEnabled ? borderColor : Colors.grey.shade400,
            ),
          ),
        ),
        minimumSize: WidgetStateProperty.all<Size>(
          Size.fromHeight(height ?? AppSizes.s44),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(
          isEnabled ? backGroundColor : Colors.grey.shade400,
        ),
        elevation: WidgetStateProperty.all<double>(0),
      ),
      onPressed: isEnabled && !isLoading ? onPressed : null,
      child: isLoading
          ? SizedBox(
              height: AppSizes.s20,
              width: AppSizes.s20,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (svgIcon != null && !iconRight) ...[
                  SvgPicture.asset(
                    svgIcon!,
                    height: AppSizes.s20,
                    width: AppSizes.s20,
                    color: fontColor,
                  ),
                  SizedBox(width: AppSizes.s8),
                ],
                if (text != null)
                  CustomText(
                    text!,
                    fontSize: textSize,
                    fontWeight: fontWeight,
                    color: fontColor,
                  ),
                if (svgIcon != null && iconRight) ...[
                  SizedBox(width: AppSizes.s8),
                  SvgPicture.asset(
                    svgIcon!,
                    height: AppSizes.s20,
                    width: AppSizes.s20,
                    color: fontColor,
                  ),
                ],
              ],
            ),
    );
  }
}