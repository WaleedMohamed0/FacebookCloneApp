import 'package:flutter/material.dart';
import 'package:social_app/screens/profile_screen/edit_profile_screen.dart';

import '../models/menu_model.dart';
import '../models/posts_additions.dart';

const defaultColor = Colors.blue;
const transparentColor = Colors.transparent;
String loggedUserID = "";
String defaultMaleProfilePhoto =
    'https://freepikpsd.com/file/2019/10/default-avatar-png-Transparent-Images.png';
String defaultFemaleProfilePhoto =
    'https://images.assetsdelivery.com/compings_v2/thesomeday123/thesomeday1231712/thesomeday123171200008.jpg';
String defaultCoverPhoto = 'https://wallpaperaccess.com/full/1690371.jpg';
List<PostsAddition> postsAdditionList = [
  PostsAddition(iconData: Icons.live_tv, iconColor: Colors.red, text: 'Live',),
  PostsAddition(iconData: Icons.photo, iconColor: Colors.green, text: 'Photo'),
  PostsAddition(
      iconData: Icons.flag, iconColor: Colors.indigo, text: 'Life event'),
];
List<String> profileTexts = [
  "Name",
  "Password",
  "Phone",
  "Age",
  "Education",
  "Residence"
];
RegExp englishRegex = RegExp("[a-zA-Z]");
List<MenuModel> menuList = [
  MenuModel(
      iconData: Icons.person,
      text: "Edit Your Profile",
      screen: EditProfileScreen(),
      ),
  MenuModel(
      iconData: Icons.dark_mode_outlined,
      text: "Dark Mode",
      darkMode: true,
),
  MenuModel(
      iconData: Icons.logout,
      text: "SignOut",
      signOut: true),
];