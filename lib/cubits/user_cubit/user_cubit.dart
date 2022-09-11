import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io' as Io;
import 'package:social_app/cubits/user_cubit/user_states.dart';
import 'package:social_app/models/post_model.dart';
import 'dart:io';
import '../../components/constants.dart';
import '../../models/user_data.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(InitialAppState());

  static UserCubit get(context) => BlocProvider.of(context);

  bool isPass = true;

  void changePasswordVisibility() {
    isPass = !isPass;
    emit(ChangePasswordVisibilityState());
  }

  UserModel? userLogged;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      getUsersData(email: email);
      emit(LoginSuccessState());
    }).catchError((error) {
      emit(LoginErrorState());
    });
  }

  void userRegister({
    required String email,
    required String phone,
    required String name,
    required String password,
    required String age,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUser(
          uId: value.user!.uid,
          name: name,
          email: email,
          phone: phone,
          password: password,
          age: age);

      emit(RegisterSuccessState());
    }).catchError((error) {
      emit(RegisterErrorState());
    });
  }

  void createUser({required String email,
    required String phone,
    required String name,
    required String password,
    required String uId,
    required String age}) {
    UserModel userModel = UserModel(
        name: name,
        email: email,
        password: password,
        phone: phone,
        gender: gender,
        uId: uId,
        age: age,
        profilePhoto: gender == 'Male'
            ? 'https://freepikpsd.com/file/2019/10/default-avatar-png-Transparent-Images.png'
            : 'https://images.assetsdelivery.com/compings_v2/thesomeday123/thesomeday1231712/thesomeday123171200008.jpg',
        coverPhoto: 'https://wallpaperaccess.com/full/1690371.jpg',
        education: 'Add Your Education',
        residence: 'Add Your Residence');
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toMap())
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(CreateUserErrorState());
    });
  }

  String gender = "";

  void changeGender(String value) {
    gender = value;
    emit(ChangeGenderState());
  }

  bool gotProfileData = false;
  List<UserModel> users = [];

  void getUsersData({required String email}) {
    emit(GetUsersDataLoadingState());
    users = [];
    // search in all users data
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        // to get user's logged data
        if (element['email'] == email) {
          loggedUserID = element['uId'];
          userLogged = UserModel(
            name: element['name'],
            password: element['password'],
            phone: element['phone'],
            age: element['age'],
            gender: element['gender'],
            uId: element['uId'],
            residence: element['residence'],
            education: element['education'],
            email: element['email'],
            profilePhoto: element['profilePhoto'],
            coverPhoto: element['coverPhoto'],
          );
        }
        // to get all users' data
        else
          {
            users.add(UserModel(name: element['name'],
                email: element['email'],
                phone: element['phone'],
                uId: element['uId'],
                profilePhoto: element['profilePhoto'],
                coverPhoto: element['coverPhoto'],
                education: element['education'],
                residence: element['residence'],
                age: element['age'],
                gender: element['gender']));
          }
      }
      gotProfileData = true;
      emit(GetUsersDataSuccessState());
    }).catchError((error) {
      emit(GetUsersDataErrorState());
    });
  }


  final ImagePicker profileImagePicker = ImagePicker();
  File? profileImagePath;
  final ImagePicker coverImagePicker = ImagePicker();
  File? coverImagePath;

  void changeProfilePhoto() {
    profileImagePicker.pickImage(source: ImageSource.gallery).then((value) {
      profileImagePath = Io.File(value!.path);

      emit(GotImagePathSuccessState());
    });
  }

  void changeCoverPhoto() {
    coverImagePicker.pickImage(source: ImageSource.gallery).then((value) {
      coverImagePath = Io.File(value!.path);
      emit(GotImagePathSuccessState());
    });
  }

  String profileImageUrl = "";

  String coverImageUrl = "";

  Future<void> uploadUserImages({
    String? name,
    String? password,
    String? phone,
    String? age,
    String? education,
    String? residence,
  }) async {
    if (profileImagePath != null) {
      emit(UploadProfileImageState());
      FirebaseStorage.instance
          .ref()
          .child('users/${Uri
          .file(profileImagePath!.path)
          .pathSegments
          .last}')
          .putFile(profileImagePath!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          profileImageUrl = value;
          updateUser(
              name: name,
              age: age,
              password: password,
              phone: phone,
              education: education,
              residence: residence);
          profileImagePath = null;
        }).catchError((error) {});
      }).catchError((error) {});
    }
    if (coverImagePath != null) {
      emit(UploadCoverImageState());
      FirebaseStorage.instance
          .ref()
          .child('users/${Uri
          .file(coverImagePath!.path)
          .pathSegments
          .last}')
          .putFile(coverImagePath!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          coverImageUrl = value;
          updateUser(
              name: name,
              age: age,
              password: password,
              phone: phone,
              education: education,
              residence: residence);
          coverImagePath = null;
        }).catchError((error) {});
      }).catchError((error) {});
    }
  }

  void updateUser({
    String? name,
    String? password,
    String? phone,
    String? age,
    String? education,
    String? residence,
  }) {
    emit(UpdateUserLoadingState());
    FirebaseAuth.instance.currentUser!.updatePassword(password!);
    FirebaseFirestore.instance.collection('users').doc(loggedUserID).update({
      'name': name,
      'password': password,
      'age': age,
      'phone': phone,
      'education': education,
      'residence': residence,
      'profilePhoto':
      profileImageUrl == "" ? userLogged!.profilePhoto : profileImageUrl,
      'coverPhoto':
      coverImageUrl == "" ? userLogged!.coverPhoto : coverImageUrl,
    }).then((value) {
      getUsersData(email: userLogged!.email!);
      emit(UpdateUserSuccessState());
    }).catchError((error) {
      emit(UpdateUserErrorState());
    });
  }


}
