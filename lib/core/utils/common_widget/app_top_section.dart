import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:range_wave/gen/assets.gen.dart';

class AppTopLogo extends StatelessWidget {
  const AppTopLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Assets.images.logoTitle.image(
      width: 210.w,
      height: 28.h,
      fit: BoxFit.contain,
    );
  }
}
