class CommentModel {
  String name = "", uId = "", profilePhoto = "", commentText = "";

  CommentModel(
      {required this.profilePhoto,
      required this.name,
      required this.uId,
      required this.commentText});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'comment': commentText,
      'uId': uId,
      'profilePhoto': profilePhoto,
    };
  }
}
