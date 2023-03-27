// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatModel {
  String text;
  Message type;
  ChatModel({
    required this.text,
    required this.type,
  });
}

enum Message { user, bot }
