import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:range_wave/core/utils/common_widget/app_title.dart';
import 'bill_row.dart';

Widget billingSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppTitle(title: 'Bill', isShowAll: false, onTap: () {}),
      SizedBox(height: 20.h),
      BillRow(title: 'Mechanic Arrived', time: '10.30 AM', price: '\$550'),
      SizedBox(height: 16.h),
      BillRow(title: 'Oil Changes', time: '10.55 AM', price: '\$123'),
      SizedBox(height: 16.h),
      BillRow(title: 'Break Pad', time: '11.00 AM', price: '\$550'),
      SizedBox(height: 16.h),
      BillRow(title: 'Extra Service Charge', time: '11.30 AM', price: '\$200'),
      SizedBox(height: 16.h),
      BillRow(title: 'Total', time: '', price: '\$2200', isShowTime: false),
    ],
  );
}