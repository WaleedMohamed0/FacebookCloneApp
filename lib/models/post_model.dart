class PostModel {
  String name = "",
      uId = "",
      profilePhoto = "",
      coverPhoto = "",
      text = "",
      postImage = "",
      dateTime = "",
      education = "",
      residence = "";

  PostModel(
      {required this.text,
      required this.name,
      required this.uId,
      required this.postImage,
      required this.profilePhoto,
      required this.coverPhoto,
      required this.education,
      required this.residence,
      required this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'text': text,
      'postImage': postImage,
      'profilePhoto': profilePhoto,
      'coverPhoto': coverPhoto,
      'dateTime': dateTime,
      'education': education,
      'residence': residence,
    };
  }
}
