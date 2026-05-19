import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../color/app_colors.dart';

class IconContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final String path;
  final Color? color;
  final Color? iconColor;
  final VoidCallback? onTap;
  final double? border;
  final Color? bgColor;
  final double? iconWidth;
  final double? iconHeight;

  const IconContainer({
    super.key,
    required this.path,
    this.color,
    this.width,
    this.onTap,
    this.height,
    this.iconColor,
    this.border,
    this.bgColor,
    this.iconWidth,
    this.iconHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 50.w,
        height: height ?? 50.h,
        decoration: BoxDecoration(
          color: bgColor ?? color?.withValues(alpha: 0.1) ?? AppColors.surface,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: border != null
                ? AppColors.border.withValues(alpha: 0.4)
                : Colors.transparent,
            width: border ?? 0,
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            path,
            width: iconWidth ?? 24.w,
            height: iconHeight ?? 24.h,
            fit: BoxFit.cover,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}