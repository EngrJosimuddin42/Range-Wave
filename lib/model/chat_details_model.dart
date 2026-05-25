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