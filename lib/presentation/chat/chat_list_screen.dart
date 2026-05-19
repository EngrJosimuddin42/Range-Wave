import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/utils/color/app_colors.dart';
import '../../model/user_chat_model.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<ChatListScreen> {
  List<ChatUser> chatUsers = [
    ChatUser(
      name: 'Jony Gomes',
      message: 'Hello, how are you? 😉',
      imageUrl:
          'https://images.pexels.com/photos/1161267/pexels-photo-1161267.jpeg',
    ),
    ChatUser(
      name: 'Sarah Khan',
      message: 'Let’s catch up tomorrow!',
      imageUrl:
          'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg',
    ),
    ChatUser(
      name: 'Jony Gomes',
      message: 'Hello, how are you? 😉',
      imageUrl:
          'https://images.pexels.com/photos/1161267/pexels-photo-1161267.jpeg',
    ),
    ChatUser(
      name: 'Jony Gomes',
      message: 'Hello, how are you? 😉',
      imageUrl:
          'https://images.pexels.com/photos/1161267/pexels-photo-1161267.jpeg',
    ),
    ChatUser(
      name: 'Jony Gomes',
      message: 'Hello, how are you? 😉',
      imageUrl:
          'https://images.pexels.com/photos/1161267/pexels-photo-1161267.jpeg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.surface,
        title: Text('Chats'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chatUsers.length,
                itemBuilder: (context, index) {
                  final user = chatUsers[index];

                  return ListTile(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.chatDetailScreen,
                        arguments: {
                          'name': user.name,
                          'imageUrl': user.imageUrl,
                        },
                      );
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.imageUrl),
                    ),
                    title: Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                      ),
                    ),
                    subtitle: Text(
                      user.message,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
