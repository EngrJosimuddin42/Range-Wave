import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscure;
  final Color? filColor;
  final Widget? prefixIcon;
  final String? hintText;
  final double? contentPaddingHorizontal;
  final double? contentPaddingVertical;
  final Widget? suffixIcon;
  final FormFieldValidator? validator;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final bool isPassword;
  final bool? isEmail;
  final bool? filled;
  final bool? readOnly;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    this.contentPaddingHorizontal,
    this.contentPaddingVertical,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.isEmail,
    this.onFieldSubmitted,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isObscureText = false,
    this.filled = false,
    this.readOnly = false,
    this.obscure = '*',
    this.onChanged,
    this.filColor,
    // this.labelText,
    this.isPassword = false,
    this.onTap,
    // this.isRequired = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // if (widget.labelText != null)
        //   _buildLabel(widget.labelText!, required: widget.isRequired),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscuringCharacter: widget.obscure!,
          minLines: widget.minLines,
          maxLines: widget.maxLines ?? 1,
          validator: widget.validator,
          onFieldSubmitted: widget.onFieldSubmitted,
          onChanged: widget.onChanged,
          maxLength: widget.maxLength,
          obscureText: widget.isPassword ? obscureText : false,
          readOnly: widget.readOnly ?? false,
          onTap: widget.onTap,

          style: TextStyle(
            color: Color(0xFF545454),
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            filled: widget.filled,
            contentPadding: EdgeInsets.symmetric(
              horizontal: widget.contentPaddingHorizontal ?? 15.w,
              vertical: widget.contentPaddingVertical ?? 15.w,
            ),
            fillColor: widget.filColor,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.prefixIcon,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: AppColors.textPrimary.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: AppColors.textPrimary.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: AppColors.textPrimary.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onTap: toggle,
                    child: _suffixIcon(
                      obscureText ? Iconsax.eye_slash : Iconsax.eye,
                    ),
                  )
                : widget.suffixIcon,
            prefixIconConstraints: BoxConstraints(
              minHeight: 24.w,
              minWidth: 24.w,
            ),
            // labelText: widget.labelText,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: AppColors.hintText,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  _suffixIcon(IconData icon) {
    return Padding(
      padding: EdgeInsets.all(14.h),
      child: Icon(icon, size: 20.sp),
    );
  }
}
