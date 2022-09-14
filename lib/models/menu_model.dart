import 'package:flutter/cupertino.dart';

class MenuModel {
  IconData? iconData;
  Widget? screen;
  String? text;
  bool? signOut;
  bool? darkMode;

  MenuModel({
    this.darkMode=false,
    required this.text,
    this.signOut=false,
    required this.iconData,
    this.screen,
  });
}