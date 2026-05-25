import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/chat_controller.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/utils/color/app_colors.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Chats',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Obx(() {

          if (controller.isChatListLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.chatUsers.isEmpty) {
            return const Center(child: Text("No conversations found."));
          }

          return ListView.builder(
            itemCount: controller.chatUsers.length,
            itemBuilder: (context, index) {
              final user = controller.chatUsers[index];

              return ListTile(
                onTap: () {
                  controller.getChatHistory(user.name);
                  Get.toNamed(
                    AppRoutes.chatDetailScreen,
                    arguments: {
                      'name': user.name,
                      'imageUrl': user.imageUrl,
                    },
                  );
                },
                contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                leading: CircleAvatar(
                  radius: 24.r,
                  backgroundImage: NetworkImage(user.imageUrl),
                ),
                title: Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                ),
                subtitle: Text(
                  user.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}