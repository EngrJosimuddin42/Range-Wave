import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/custom_text_field.dart';
import '../../controller/chat_controller.dart';
import '../../gen/assets.gen.dart';
import '../../model/chat_details_model.dart';

class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.find<ChatController>();

    final data = Get.arguments as Map<String, dynamic>;
    final String name = data['name'];
    final String imageUrl = data['imageUrl'];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        automaticallyImplyLeading: true,
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 18.r),
            SizedBox(width: 10.w),
            Text(
              name,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isChatHistoryLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  itemCount: controller.chatMessages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: _chatItem(controller.chatMessages[index]),
                    );
                  },
                );
              }),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: CustomTextField(
                controller: controller.messageController,
                hintText: 'Type your message',
                keyboardType: TextInputType.text,
                prefixIcon: GestureDetector(
                  onTap: () {
                    // মিডিয়া বা ফাইল অ্যাটাচমেন্টের কাজ এখানে হবে
                  },
                  child: Assets.icons.addIconBlack.svg(
                    width: 28.w,
                    height: 28.w,
                    fit: BoxFit.contain,
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () => controller.sendMessage(name),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Assets.icons.send.svg(
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(
                        AppColors.textPrimary,
                        BlendMode.srcIn,
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


  Widget _chatItem(ChatDetailsModel chat) {
    final isMe = chat.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: isMe
              ? BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
            bottomLeft: Radius.circular(20.r),
          )
              : BorderRadius.only(
            topRight: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r),
            bottomLeft: Radius.circular(20.r),
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
}