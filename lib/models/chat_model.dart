class ChatModel {
  String text = "",
      receiverId = "",
      senderId = "",
      dateTime = "",
      chatImage = "";

  ChatModel(
      {required this.receiverId,
      required this.senderId,
      required this.text,
      required this.dateTime,
      this.chatImage = ""});

  Map<String, dynamic> toMap() {
    return {
      'receiverId': receiverId,
      'senderId': senderId,
      'text': text,
      'dateTime': dateTime,
      'chatImage': chatImage,
    };
  }
}
