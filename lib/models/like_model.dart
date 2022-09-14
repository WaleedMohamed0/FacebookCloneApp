class LikeModel {
  String name = "", profilePhoto = "", uId = "";

  LikeModel(
      {required this.name, required this.uId, required this.profilePhoto});

  LikeModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    profilePhoto = json['profilePhoto'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'profilePhoto': profilePhoto,
    };
  }
}
