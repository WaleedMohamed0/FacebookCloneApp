import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/cubits/posts_cubit/posts_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/models/user_data.dart';
import 'package:social_app/my_flutter_app_icons.dart';
import 'package:social_app/screens/posts_screen/comments_screen.dart';

import '../models/post_model.dart';
import '../screens/profile_screen/profile_screen.dart';
import 'constants.dart';

void navigateTo({required context, required nextScreen}) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => nextScreen,
    ));

void navigateToWithAnimation(
        {required context,
        required nextScreen,
        PageTransitionType? pageTransitionType,
        int durationInMilliSecs = 400}) =>
    Navigator.of(context, rootNavigator: true).push(PageTransition(
        child: nextScreen,
        type: pageTransitionType!,
        duration: Duration(milliseconds: durationInMilliSecs)));

void navigateAndFinish(context, nextPage) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => nextPage),
    (route) => false);

Widget defaultTextField({
  String? hintText,
  TextStyle? hintStyle,
  Widget? prefixIcon,
  bool isPass = false,
  IconData? suffix,
  TextEditingController? controller,
  required TextInputType textInput,
  Function()? suffixPressed,
  Function(String val)? onSubmit,
  String? Function(String? value)? valid,
  Color fillColor = Colors.white,
  int maxLines = 1,
  bool profileFields = false,
  double contentPadding = 20,
  double borderRadius = 10,
  Function()? onTap
}) {
  return TextFormField(
      maxLines: maxLines,
      textAlignVertical: TextAlignVertical.top,
      keyboardType: textInput,
      controller: controller,
      onFieldSubmitted: onSubmit,
      obscureText: isPass,
      onTap: onTap,
      enableSuggestions: true,
      decoration: !profileFields
          ? InputDecoration(
              alignLabelWithHint: true,
              hintStyle: hintStyle,
              hintText: hintText,
              contentPadding: EdgeInsets.all(contentPadding),
              border: InputBorder.none,
              fillColor: fillColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Colors.white, width: 10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Colors.white, width: 10),
              ),
              prefixIcon: prefixIcon,
              suffixIcon: IconButton(
                icon: Icon(
                  suffix,
                  color: defaultColor,
                ),
                onPressed: suffixPressed,
              ),
            )
          : InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: valid);
}

Widget searchTextField({
  required Function(String searchQuery) onChange,
}) =>
    TextFormField(
      keyboardType: TextInputType.text,
      onChanged: (String searchQuery) {
        onChange(searchQuery);
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(25),
        prefixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(28, 10, 10, 10),
          child: Icon(
            Icons.search,
          ),
        ),
        hintText: "Search",
        hintStyle: TextStyle(color: HexColor('979797')),
        fillColor: HexColor('F8F8F8'),
        filled: true,
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white, width: 10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white, width: 10),
        ),
      ),
    );

Widget defaultText(
        {required String text,
        double? fontSize,
        double? letterSpacing,
        isUpperCase = false,
        textColor,
        double? textHeight,
        double? wordSpacing,
        maxLines,
        TextOverflow? textOverflow,
        FontStyle? fontStyle,
        TextStyle? hintStyle,
        TextAlign? textAlign,
        FontWeight? fontWeight,
        String? fontFamily,
        TextStyle? myStyle,
        TextDirection? textDirection}) =>
    Text(
      isUpperCase ? text.toUpperCase() : text,
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlign,
      // textDirection:TextDirection.LTR,
      style: myStyle ??
          TextStyle(
              fontFamily: fontFamily,
              fontSize: fontSize,
              color: textColor,
              fontWeight: fontWeight,
              height: textHeight,
              fontStyle: fontStyle,
              letterSpacing: letterSpacing,
              wordSpacing: wordSpacing),
    );

Widget defaultBtn({
  double? width,
  Color backgroundColor = defaultColor,
  Color textColor = Colors.white,
  bool isUpperCase = false,
  double borderRadius = 10,
  required String txt,
  required VoidCallback function,
  IconData? icon,
  double fontSize = 20,
  Color borderColor = defaultColor,
  EdgeInsets padding = EdgeInsets.zero,
  double borderWidth = 2,
}) {
  return Container(
    width: width ?? Adaptive.w(83),
    padding: padding,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor, width: borderWidth),
      color: backgroundColor,
    ),
    child: TextButton(
      onPressed: function,
      child: Text(
        isUpperCase ? txt.toUpperCase() : txt,
        style:
            TextStyle(fontSize: fontSize, color: textColor, letterSpacing: 1.5),
      ),
    ),
  );
}

Widget defaultBtnWithIcon({
  double left_margin_icon = 10,
  double right_margin_icon = 10,
  double right_margin_text = 20,
  double? width,
  Color backgroundcolor = defaultColor,
  bool isUpperCase = false,
  double BorderRadValue = 31,
  required String txt,
  required VoidCallback function,
  IconData? icon,
  double fontSize = 20,
}) {
  return Container(
    width: width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(BorderRadValue),
      color: backgroundcolor,
    ),
    child: TextButton.icon(
      icon: Container(
        margin:
            EdgeInsets.only(right: right_margin_icon, left: left_margin_icon),
        child: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
      ),
      onPressed: function,
      label: Container(
        margin:
            EdgeInsets.only(right: right_margin_text, left: left_margin_icon),
        child: Text(
          isUpperCase ? txt.toUpperCase() : txt,
          style: TextStyle(
              fontSize: fontSize,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
        ),
      ),
    ),
  );
}

Future defaultDialog(
        {required context,
        required text,
        required declineText,
        required acceptText,
        required void Function()? declineFn,
        required void Function()? acceptFn}) =>
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  defaultText(text: text, fontSize: 18),
                ],
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: TextButton(
                        onPressed: declineFn,
                        child: defaultText(
                            text: declineText,
                            textColor: Colors.white,
                            fontSize: 14.5)),
                    width: Adaptive.w(27),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: defaultColor,
                    ),
                  ),
                  Container(
                    width: Adaptive.w(27),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: defaultColor,
                    ),
                    child: TextButton(
                        onPressed: acceptFn,
                        child: defaultText(
                            text: acceptText,
                            textColor: Colors.white,
                            fontSize: 14.5)),
                  ),
                ],
              ));
        });

Widget defaultIconButton(
        {required IconData icon,
        double size = 22,
        Color color = defaultColor,
        required Function onPressed,
        BoxConstraints? constraints,
        EdgeInsets padding = EdgeInsets.zero}) =>
    IconButton(
        hoverColor: transparentColor,
        splashColor: transparentColor,
        highlightColor: transparentColor,
        padding: padding,
        constraints: constraints,
        onPressed: () {
          onPressed();
        },
        icon: Icon(icon, size: size, color: color));

AppBar defaultAppBar(
        {String title = "",
        FontWeight? fontWeight = FontWeight.w600,
        Color textColor = Colors.white,
        Widget? leading,
        double? fontSize,
        double? toolbarHeight,
        List<Widget>? actions,
        Color foregroundColor = Colors.black,
        double? elevation,
          bool centerTitle = false,
        Color? backgroundColor,
        PreferredSizeWidget? preferredSizeWidget}) =>
    AppBar(
      foregroundColor: foregroundColor,
      leadingWidth: 30,
      backgroundColor: backgroundColor,
      toolbarHeight: toolbarHeight,
      actions: actions,
      elevation: elevation,
      leading: leading,
      bottom: preferredSizeWidget,
      centerTitle: centerTitle,
      title: defaultText(
          text: title,
          fontWeight: fontWeight,
          textColor: textColor,
          fontSize: fontSize),
    );

Future<bool?> defaultToast(
    {required String msg,
    Color textColor = Colors.white,
    Color backgroundColor = defaultColor}) {
  Fluttertoast.cancel();
  return Fluttertoast.showToast(
      msg: msg, textColor: textColor, backgroundColor: backgroundColor);
}

Widget buildPost(PostModel post, PostsCubit postsCubit, postIndex, context,
    UserModel currentUser) {
  return Padding(
    padding: EdgeInsets.only(bottom: Adaptive.h(1.5)),
    child: Card(
      elevation: 10,
      child: Column(
        crossAxisAlignment: englishRegex.hasMatch(post.text)
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Adaptive.w(2), vertical: Adaptive.h(3)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    postsCubit.getOtherUsersPosts(uId: post.uId);
                    navigateToWithAnimation(
                        context: context,
                        nextScreen: ProfileScreen(userModel: post),
                        pageTransitionType: PageTransitionType.rightToLeft);
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      post.profilePhoto,
                    ),
                    radius: 25,
                  ),
                ),
                SizedBox(
                  width: Adaptive.w(3),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            postsCubit.getOtherUsersPosts(uId: post.uId);
                            navigateToWithAnimation(
                                context: context,
                                nextScreen: ProfileScreen(userModel: post),
                                pageTransitionType:
                                    PageTransitionType.rightToLeft);
                          },
                          child: defaultText(
                              text: post.name,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                        SizedBox(
                          width: Adaptive.w(1),
                        ),
                        Icon(
                          Icons.check_circle,
                          color: Colors.blue,
                          size: 20,
                        )
                      ],
                    ),
                    SizedBox(
                      height: Adaptive.h(.4),
                    ),
                    defaultText(text: post.dateTime, textColor: Colors.grey),
                  ],
                ),
                Spacer(),
                if (post.uId == loggedUserID)
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.grey[200],
                    child: defaultIconButton(
                      icon: Icons.close,
                      onPressed: () {
                        defaultDialog(
                            text: 'Are you sure to remove this post ?',
                            context: context,
                            declineText: 'Back',
                            acceptText: 'Remove',
                            acceptFn: () {
                              postsCubit.removePost(
                                  postId: postsCubit.postsId[postIndex],
                                  postIndex: postIndex);
                              Navigator.of(context, rootNavigator: true)
                                  .pop(context);
                            },
                            declineFn: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pop(context);
                            });
                      },
                      color: Colors.black,
                    ),
                  )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
                child: defaultText(
                  text: post.text,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(
            height: Adaptive.h(2),
          ),
          if (post.postImage != "")
            Center(
              child: Image.network(
                post.postImage,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Adaptive.w(5), vertical: Adaptive.h(2)),
            child: Row(
              children: [
                Icon(myIcons.like),
                SizedBox(
                  width: Adaptive.w(2),
                ),
                defaultText(text: '${postsCubit.likes[postIndex]}'),
                SizedBox(
                  width: Adaptive.w(5.5),
                ),
                // Spacer(),
                // defaultText(text: '2 shares')
              ],
            ),
          ),
          Divider(
            color: Colors.grey[600],
            height: 2,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Adaptive.w(5.5), vertical: Adaptive.h(1.3)),
            child: Row(
              children: [
                Flexible(
                  child: InkWell(
                    onTap: () {
                      postsCubit.likePost(
                          postId: postsCubit.postsId[postIndex],
                          index: postIndex,
                          currentUser: currentUser);
                    },
                    child: Row(
                      children: [
                        Icon(myIcons.like),
                        SizedBox(
                          width: Adaptive.w(2.3),
                        ),
                        defaultText(text: 'Like'),
                      ],
                    ),
                  ),
                ),
                Flexible(
                    child: InkWell(
                  onTap: () {
                    postsCubit.getComments(
                        postId: postsCubit.postsId[postIndex]);
                    postsCubit.getLikedUsers(
                        postId: postsCubit.postsId[postIndex],
                        context: context,
                        index: postIndex);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.chat_bubble_outline),
                      SizedBox(
                        width: Adaptive.w(1),
                      ),
                      defaultText(text: 'Comment'),
                    ],
                  ),
                )),
                Flexible(
                  child: InkWell(
                    onTap: () {
                      defaultDialog(
                          text: 'Are you sure to share this post ?',
                          context: context,
                          declineText: 'Back',
                          acceptText: 'Share Now',
                          acceptFn: () {
                            postsCubit.sharePost(
                                post: post, currentUser: currentUser);
                            Navigator.of(context, rootNavigator: true)
                                .pop(context);
                          },
                          declineFn: () {
                            Navigator.of(context, rootNavigator: true)
                                .pop(context);
                          });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.ios_share),
                        SizedBox(
                          width: Adaptive.w(1),
                        ),
                        defaultText(text: 'Share'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

// EmojiPicker emojiSelect({required textEditingController}) {
//
//   return EmojiPicker(
//     textEditingController: textEditingController,
//     onEmojiSelected: (emoji, category) {
//       textEditingController.text = textEditingController.text + emoji;
//     },
//     config: Config(
//       columns: 7,
//       emojiSizeMax: 32, // Issue: https://github.com/flutter/flutter/issues/28894
//       verticalSpacing: 0,
//       horizontalSpacing: 0,
//       gridPadding: EdgeInsets.zero,
//       initCategory: Category.RECENT,
//       bgColor: Color(0xFFF2F2F2),
//       indicatorColor: Colors.blue,
//       iconColor: Colors.grey,
//       iconColorSelected: Colors.blue,
//       progressIndicatorColor: Colors.blue,
//       backspaceColor: Colors.blue,
//       skinToneDialogBgColor: Colors.white,
//       skinToneIndicatorColor: Colors.grey,
//       enableSkinTones: true,
//       showRecentsTab: true,
//       recentsLimit: 28,
//       noRecents: const Text(
//         'No Recents',
//         style: TextStyle(fontSize: 20, color: Colors.black26),
//         textAlign: TextAlign.center,
//       ),
//       tabIndicatorAnimDuration: kTabScrollDuration,
//       categoryIcons: const CategoryIcons(),
//       buttonMode: ButtonMode.MATERIAL,
//     ),
//   );
// }
