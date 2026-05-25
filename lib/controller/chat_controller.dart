import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../model/user_chat_model.dart';
import '../model/chat_details_model.dart';

class ChatController extends GetxController {
  RxBool isChatListLoading = false.obs;
  RxBool isChatHistoryLoading = false.obs;

  RxList<ChatUser> chatUsers = <ChatUser>[].obs;
  RxList<ChatDetailsModel> chatMessages = <ChatDetailsModel>[].obs;

  final TextEditingController messageController = TextEditingController();

  // ── 🌟 সকেট অবজেক্ট ডিফাইন করা ──
  late IO.Socket socket;

  @override
  void onInit() {
    super.onInit();
    getChatList();
    //  initSocket();  // 👈 ব্যাকএন্ড রেডি হওয়ার আগ পর্যন্ত চাইলে এভাবে কমেন্ট করে রাখতে পারেন
  }

  // ── 🌟 WebSocket কানেকশন এবং রিয়েল-টাইম লিসেনার ──
  void initSocket() {
    // TODO: ব্যাকএন্ড রেডি হলে আপনার আসল সকেট ইউআরএলটি এখানে বসাবেন
    String socketUrl = "YOUR_BACKEND_SOCKET_URL_HERE";

    socket = IO.io(socketUrl, IO.OptionBuilder()
        .setTransports(['websocket']) // অবশই ওয়েবসকেট ট্রান্সপোর্ট সেট করতে হবে
        .disableAutoConnect()        // ম্যানুয়ালি কানেক্ট করার জন্য
        .build()
    );

    socket.connect();

    socket.onConnect((_) {
      debugPrint('Connected to WebSocket Server ✅');
    });

    // ── 🌟 লাইভ মেসেজ রিসিভ করার লিসেনার ──
    // যখনই মেকানিক কোনো মেসেজ পাঠাবে, সকেট এই ইভেন্টটি ক্যাচ করে স্ক্রিনে রিয়েল-টাইম রিফ্রেশ করবে
    // TODO: 'receive_message' এর নাম ব্যাকএন্ড ডেভলপারের সাথে মিলিয়ে চেঞ্জ করতে হতে পারে
    socket.on('receive_message', (data) {
      if (data != null) {
        final incomingMessage = ChatDetailsModel(
          message: data['message'] ?? "",
          isMe: false, // মেকানিক পাঠিয়েছে তাই false
          time: DateTime.now(),
        );

        chatMessages.insert(0, incomingMessage);
      }
    });

    socket.onDisconnect((_) => debugPrint('Disconnected from WebSocket Server ❌'));
  }

  Future<void> getChatList() async {
    isChatListLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));
      chatUsers.value = [
        ChatUser(
          name: 'Jony Gomes',
          message: 'Hello, how are you? 😉',
          imageUrl: 'https://images.pexels.com/photos/1161267/pexels-photo-1161267.jpeg',
        ),
      ];
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isChatListLoading.value = false;
    }
  }

  Future<void> getChatHistory(String userId) async {
    isChatHistoryLoading.value = true;
    chatMessages.clear();
    try {
      // চ্যাট রুমে জয়েন করার জন্য সকেট এমিট (যদি ব্যাকএন্ডে রুম সিস্টেম থাকে)
      // socket.emit('join_room', userId);

      await Future.delayed(const Duration(milliseconds: 500));
      chatMessages.value = [
        ChatDetailsModel(message: "Hi! how can I help?", isMe: true, time: DateTime.now()),
      ];
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isChatHistoryLoading.value = false;
    }
  }


  void sendMessage(String receiverId) {
    String text = messageController.text.trim();
    if (text.isEmpty) return;

    final newMessage = ChatDetailsModel(
      message: text,
      isMe: true,
      time: DateTime.now(),
    );
    chatMessages.insert(0, newMessage);
    messageController.clear();

    try {
      // ── 🌟 সকেটের মাধ্যমে মেকানিকের ফোনে মেসেজ পাঠানো ──
      // TODO: 'send_message' নাম এবং ম্যাপের 'Key' গুলো ব্যাকএন্ড ডেভলপারের রিকোয়ারমেন্ট অনুযায়ী চেঞ্জ করবেন
      socket.emit('send_message', {
        'receiver_id': receiverId,
        'message': text,
        'timestamp': DateTime.now().toIso8601String(),
      });

    } catch (e) {
      debugPrint("Error sending message via socket: $e");
    }
  }

  @override
  void onClose() {
    socket.disconnect();
    socket.dispose();
    messageController.dispose();
    super.onClose();
  }
}