import 'package:flutter/material.dart';

import '../models/posts_additions.dart';

const defaultColor = Colors.blue;
const transparentColor = Colors.transparent;
String loggedUserID = "";
List<PostsAddition> postsAdditionList = [
  PostsAddition(iconData: Icons.live_tv,iconColor: Colors.red, text: 'Live', onPressed: () {}),
  PostsAddition(iconData: Icons.photo,iconColor: Colors.green, text: 'Photo', onPressed: () {}),
  PostsAddition(iconData: Icons.flag,iconColor: Colors.indigo, text: 'Life event', onPressed: () {}),
];
List<String> profileTexts =
[
  "Name",
  "Password",
  "Phone",
  "Age",
  "Education",
  "Residence"
];
