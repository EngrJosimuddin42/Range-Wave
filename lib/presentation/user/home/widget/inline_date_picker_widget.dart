import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../controller/scheduled_service_controller.dart';
import '../../../../core/utils/color/app_colors.dart';

class InlineDatePickerWidget extends StatelessWidget {
  final ScheduledServiceController controller;

  const InlineDatePickerWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Table Calendar Section ──
          Obx(() => TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime(2030),
            focusedDay: controller.focusedDay.value,
            currentDay: DateTime.now(),
            rowHeight: 38.h,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 20.w),
              rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.textPrimary, size: 20.w),
              decoration: BoxDecoration(
                color: AppColors.blueish.withValues(alpha: 0.5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textTernary),
              weekendStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textTernary),
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: true,
              outsideTextStyle: TextStyle(color: Colors.grey.shade300, fontSize: 12.sp),
              defaultTextStyle: TextStyle(color: AppColors.textPrimary, fontSize: 12.sp),
              weekendTextStyle: TextStyle(color: AppColors.textPrimary, fontSize: 12.sp),
              selectedDecoration: BoxDecoration(
                color: AppColors.blue,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              todayDecoration: BoxDecoration(
                color: AppColors.blue.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
            ),
            selectedDayPredicate: (day) {
              return isSameDay(controller.selectedDate.value, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              controller.setDate(selectedDay);
              controller.focusedDay.value = focusedDay;
            },
          )),

          // ── Time Picker Section ──
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) controller.setTime(picked);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Obx(() => Text(
                          controller.timeText.value,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                        )),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Obx(() => Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        children: [
                          _buildAmPmButton('AM', controller.isAm.value, () => controller.toggleAmPm(true)),
                          _buildAmPmButton('PM', !controller.isAm.value, () => controller.toggleAmPm(false)),
                        ],
                      ),
                    )),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmPmButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.textPrimary : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}