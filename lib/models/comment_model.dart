class CommentModel {
  String name = "", uId = "", profilePhoto = "", commentText = "", dateTime="";

  CommentModel(
      {required this.profilePhoto,
      required this.name,
      required this.uId,
      required this.commentText,required this.dateTime});

  CommentModel.fromJson(Map<String, dynamic> json) {
    profilePhoto = json['profilePhoto'];
    name = json['name'];
    uId = json['uId'];
    commentText = json['comment'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'comment': commentText,
      'uId': uId,
      'profilePhoto': profilePhoto,
      'dateTime': dateTime,
    };
  }
}
