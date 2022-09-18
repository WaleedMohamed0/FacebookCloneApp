class NotificationModel {
  String postId = "", name = "", profilePhoto = "", type = "";

  NotificationModel(
      {required this.name,
      required this.profilePhoto,
      required this.postId,
      required this.type});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    profilePhoto = json['profilePhoto'];
    name = json['name'];
    postId = json['postId'];
    type = json['type'];
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'profilePhoto': profilePhoto,
        'postId': postId,
        'type': type,
      };
}
