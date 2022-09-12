class UserModel {
  String email = "";
  String? name;
  String? phone;
  String? age;
  String? gender;
  String? password;
  String? uId;
  String? profilePhoto;
  String? coverPhoto;
  String? education;
  String? residence;

  UserModel(
      {required this.name,
      required this.email,
      this.password,
      required this.phone,
      required this.uId,
      required this.profilePhoto,
      required this.coverPhoto,
      required this.education,
      required this.residence,
      this.age,
      this.gender});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    password = json['password'];
    age = json['age'];
    profilePhoto = json['profilePhoto'];
    coverPhoto = json['coverPhoto'];
    education = json['education'];
    residence = json['residence'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
      'uId': uId,
      'education': education,
      'password': password,
      'residence': residence,
      'profilePhoto': profilePhoto,
      'coverPhoto': coverPhoto,
    };
  }
}
