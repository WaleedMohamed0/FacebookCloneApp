class ChatModel {
  String text = "", receiverId = "", senderId = "", dateTime = "";

  ChatModel(
      {required this.receiverId,
      required this.senderId,
      required this.text,
      required this.dateTime});


  Map<String, dynamic> toMap() {
    return {
      'receiverId': receiverId,
      'senderId': senderId,
      'text': text,
      'dateTime': dateTime,
    };
  }
}
