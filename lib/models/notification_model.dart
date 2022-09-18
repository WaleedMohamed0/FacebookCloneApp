class NotificationModel {
  String postId = "", name = "", profilePhoto = "", type = "",dateTime="",uId="";

  NotificationModel(
      {required this.name,
      required this.profilePhoto,
      required this.postId,
      required this.type,required this.dateTime,required this.uId});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    profilePhoto = json['profilePhoto'];
    name = json['name'];
    postId = json['postId'];
    type = json['type'];
    dateTime = json['dateTime'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'profilePhoto': profilePhoto,
        'postId': postId,
        'type': type,
        'dateTime': dateTime,
        'uId': uId,
      };
}
