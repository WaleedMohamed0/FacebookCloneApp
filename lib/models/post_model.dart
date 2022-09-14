import 'package:social_app/models/like_model.dart';

class PostModel {
  String name = "",
      uId = "",
      profilePhoto = "",
      text = "",
      postImage = "",
      dateTime = "";

  PostModel({
    required this.text,
    required this.name,
    required this.uId,
    required this.postImage,
    required this.profilePhoto,
    required this.dateTime,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    name = json['name'];
    uId = json['uId'];
    postImage = json['postImage'];
    profilePhoto = json['profilePhoto'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'text': text,
      'postImage': postImage,
      'profilePhoto': profilePhoto,
      'dateTime': dateTime,
    };
  }
}
