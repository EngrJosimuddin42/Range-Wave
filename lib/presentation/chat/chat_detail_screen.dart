import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/custom_text_field.dart';

import '../../gen/assets.gen.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _UserChatDetailsScreenState();
}

class _UserChatDetailsScreenState extends State<ChatDetailScreen> {
  List<ChatDetailsModel> chatMessages = [
    ChatDetailsModel(
      message: "Hi! how can I help?",
      isMe: true,
      time: DateTime.now(),
    ),
    ChatDetailsModel(
      message: "I need some information.",
      isMe: false,
      time: DateTime.now(),
    ),
    ChatDetailsModel(
      message: "I need some information.",
      isMe: true,
      time: DateTime.now(),
    ),
    ChatDetailsModel(
      message: "I need some information.",
      isMe: false,
      time: DateTime.now(),
    ),
    ChatDetailsModel(
      message: "I need some information.",
      isMe: false,
      time: DateTime.now(),
    ),
    ChatDetailsModel(
      message: "I need some information.",
      isMe: true,
      time: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>;

    final String name = data['name'];
    final String imageUrl = data['imageUrl'];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        automaticallyImplyLeading: true,
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 20.r),
            SizedBox(width: 8.w),
            Text(name),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: chatItem(chatMessages[index]),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: CustomTextField(
                controller: TextEditingController(),
                hintText: 'Type your message',
                keyboardType: TextInputType.text,
                prefixIcon: GestureDetector(
                  onTap: () {
                    print('add');
                  },
                  child: Assets.icons.addIconBlack.svg(
                    width: 28.w,
                    height: 28.w,
                    fit: BoxFit.contain,
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    print('send');
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10.w),
                    width: 18.w,
                    height: 18.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.textPrimary,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: Assets.icons.send.svg(
                          fit: BoxFit.contain,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget chatItem(ChatDetailsModel chat) {
  final isMe = chat.isMe;

  return Align(
    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              )
            : BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
        color: isMe
            ? AppColors.primary
            : AppColors.textPrimary.withValues(alpha: 0.1),
      ),
      child: Text(
        chat.message,
        style: TextStyle(
          fontFamily: GoogleFonts.montserrat().fontFamily,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: isMe ? AppColors.white : AppColors.textPrimary,
        ),
      ),
    ),
  );
}

class ChatDetailsModel {
  final String message;
  final bool isMe;
  final DateTime time;

  ChatDetailsModel({
    required this.message,
    required this.isMe,
    required this.time,
  });
}
