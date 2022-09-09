import 'package:flutter/cupertino.dart';

class PostsAddition {
  String text = "";
  IconData? iconData;
  Color? iconColor;
  VoidCallback onPressed = () {};

  PostsAddition(
      {required this.iconData, required this.text, required this.onPressed,required this.iconColor});
}
