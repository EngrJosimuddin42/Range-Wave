import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timelines_plus/timelines_plus.dart';

class HorizontalProgressTimeline extends StatelessWidget {
  final List<String> steps;
  final int currentStep;

  const HorizontalProgressTimeline({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Timeline.tileBuilder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.after,
        itemCount: steps.length,

        indicatorBuilder: (context, index) {
          final bool isActive = index <= currentStep;
          final bool isCurrent = index == currentStep;
          return DotIndicator(
            size: 20.w,
            color: isActive ? Colors.blue : Colors.grey.shade300,
            child: isCurrent
                ? Icon(Icons.sync, color: Colors.white, size: 18.w)
                : isActive
                ? Icon(Icons.check, color: Colors.white, size: 18.w)
                : null,
          );
        },

        connectorBuilder: (context, index, type) {
          final bool isActive = index < currentStep;
          return SolidLineConnector(
            thickness: 4.h,
            color: isActive ? Colors.blue : Colors.grey.shade300,
          );
        },

        contentsBuilder: (context, index) {
          final bool isActive = index <= currentStep;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              steps[index],
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? Colors.blue : Colors.grey.shade700,
                fontFamily: GoogleFonts.manrope().fontFamily,
              ),
            ),
          );
        },
      ),
    );
  }
}