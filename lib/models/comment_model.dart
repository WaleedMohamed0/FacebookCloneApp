class CommentModel {
  String name = "",
      uId = "",
      profilePhoto = "",
      coverPhoto = "",
      education = "",
      residence = "",
      commentText = "";

  CommentModel(
      {required this.profilePhoto,
      required this.name,
      required this.uId,
      required this.coverPhoto,
      required this.education,
      required this.residence,
      required this.commentText});

  CommentModel.fromJson(Map<String, dynamic> json) {
    profilePhoto = json['profilePhoto'];
    name = json['name'];
    uId = json['uId'];
    education = json['education'];
    coverPhoto = json['coverPhoto'];
    residence = json['residence'];
    commentText = json['comment'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'comment': commentText,
      'uId': uId,
      'education': education,
      'residence': residence,
      'profilePhoto': profilePhoto,
      'coverPhoto': coverPhoto,
    };
  }
}
