import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';

class PrimaryButton extends StatefulWidget {
  final bool loading;
  final String text;
  final Color? textColor;
  final void Function()? onTap;
  final bool shadow;
  final bool disabled;
  final Color? backgroundColor;
  final Color? borderColor;
  final TextStyle? textStyle;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final Widget? leading;
  final Widget? tailing;
  final EdgeInsetsGeometry? margin;

  const PrimaryButton({
    super.key,
    this.loading = false,
    this.disabled = false,
    required this.text,
    this.height,
    this.width,
    this.leading,
    this.tailing,
    this.borderRadius,
    this.onTap,
    this.shadow = true,
    this.backgroundColor,
    this.textStyle,
    this.margin,
    this.textColor,
    this.borderColor,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.loading) return;
        widget.onTap?.call();
      },
      child: Container(
        margin: widget.margin,
        width: widget.width ?? double.infinity,
        height: widget.height ?? 48.h,
        decoration: BoxDecoration(
          color: widget.disabled ? Color(0xffF9F4FF) : widget.backgroundColor,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
          border: Border.all(
            color: widget.borderColor ?? AppColors.white,
            width: 1.w,
          ),
        ),
        child: Center(
          child: widget.loading
              ? SizedBox(
                  height: 24.w,
                  child: SpinKitWave(color: AppColors.white, size: 24.w),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.leading != null)
                      Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: widget.leading!,
                      ),
                    Text(
                      widget.text,
                      style:
                          widget.textStyle ??
                          TextStyle(
                            color: AppColors.buttonTextColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    if (widget.tailing != null)
                      Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: widget.tailing!,
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
