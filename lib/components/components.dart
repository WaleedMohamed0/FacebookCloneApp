import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/cubits/posts_cubit/posts_cubit.dart';
import 'package:social_app/cubits/theme_manager/theme_cubit.dart';
import 'package:social_app/cubits/theme_manager/theme_states.dart';
import 'package:social_app/models/user_data.dart';
import 'package:social_app/my_flutter_app_icons.dart';
import 'package:social_app/screens/comments_screen/comments_screen.dart';

import '../models/post_model.dart';
import '../screens/profile_screen/others_profile_screen.dart';
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

Widget defaultTextField(
    {String? hintText,
    TextStyle? hintStyle,
    Widget? prefixIcon,
    bool isPass = false,
    IconData? suffixIcon,
    Widget? suffixWidget,
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
    TextStyle style = const TextStyle(color: Colors.black, fontSize: 15),
    Color borderColor = Colors.white,
    Function()? onTap,
    BuildContext? context,
      bool isSuffixIcon = true,
    }) {
  return TextFormField(
      style: style,
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
                borderSide: BorderSide(color: borderColor, width: 10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: borderColor, width: 10),
              ),
              prefixIcon: prefixIcon,
              suffixIcon: isSuffixIcon ? IconButton(
                icon: Icon(
                  suffixIcon,
                  color: defaultColor,
                  size: 27,
                ),
                onPressed: suffixPressed,
              ):suffixWidget,
            )
          : InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                    color: Theme.of(context!).iconTheme.color!, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                    color: Theme.of(context).iconTheme.color!, width: 1),
              )),
      validator: valid);
}

Widget searchTextField({
  required Function(String searchQuery) onChange,
  bool isDark = false,
  context
}) =>
    TextFormField(
      keyboardType: TextInputType.text,
      style: Theme.of(context).textTheme.bodyText2,
      onChanged: (String searchQuery) {
        onChange(searchQuery);
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: Adaptive.h(2)),
        prefixIcon: Padding(
          padding: EdgeInsets.fromLTRB(
              Adaptive.w(5.5), Adaptive.h(1), Adaptive.w(3), Adaptive.h(1)),
          child: Icon(
            Icons.search,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        hintText: "Search",
        hintStyle: TextStyle(color: HexColor('979797'), fontSize: 16),
        fillColor: isDark ? HexColor('303030') : HexColor('f5f5f5'),
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.transparent, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.transparent, width: 1),
        ),
      ),
    );

Widget defaultText({
  required String text,
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
}) =>
    Text(
      isUpperCase ? text.toUpperCase() : text,
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlign,
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
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  defaultText(
                      text: text,
                      fontSize: 18,
                      textColor: Theme.of(context).textTheme.bodyText2!.color),
                ],
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Adaptive.w(27),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: defaultColor,
                    ),
                    child: TextButton(
                        onPressed: declineFn,
                        child: defaultText(
                            text: declineText,
                            textColor: Colors.white,
                            fontSize: 14.5)),
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
        Widget? leading,
        double? fontSize,
        double? toolbarHeight,
        List<Widget>? actions,
        double elevation = 0,
        bool centerTitle = false,
        Color? backgroundColor,
        PreferredSizeWidget? preferredSizeWidget}) =>
    AppBar(
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
      ),
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
  String time = getTimeDifference(dateTime: post.dateTime);
  return BlocBuilder<ThemeManagerCubit, ThemeManagerStates>(
    builder: (context, state) {
      bool isDark = ThemeManagerCubit.get(context).isDark;
      return Padding(
        padding: EdgeInsets.only(bottom: Adaptive.h(1.5)),
        child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[300]!)),
          elevation: 6,
          color: Theme.of(context).scaffoldBackgroundColor,
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
                        postsCubit.getUserClickedData(
                          uId: post.uId,
                        );
                        navigateToWithAnimation(
                            context: context,
                            nextScreen: OthersProfileScreen(),
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
                                postsCubit.getUserClickedData(
                                  uId: post.uId,
                                );
                                navigateToWithAnimation(
                                    context: context,
                                    nextScreen: OthersProfileScreen(),
                                    pageTransitionType:
                                        PageTransitionType.rightToLeft);
                              },
                              child: defaultText(
                                  text: post.name,
                                  myStyle:
                                      Theme.of(context).textTheme.bodyText1),
                            ),
                            SizedBox(
                              width: Adaptive.w(1),
                            ),
                            const Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 20,
                            )
                          ],
                        ),
                        SizedBox(
                          height: Adaptive.h(.6),
                        ),
                        Row(
                          children: [
                            defaultText(
                                text: time,
                                myStyle: Theme.of(context).textTheme.subtitle2),
                            SizedBox(width: Adaptive.w(2),),
                            const CircleAvatar(radius: 3,),
                            SizedBox(width: Adaptive.w(1),),
                            const Icon(Icons.public,size: 18,),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (post.uId == loggedUserID)
                      CircleAvatar(
                        radius: 15,
                        backgroundColor:
                            isDark ? Colors.grey[400] : Colors.grey[200],
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
                                      postId: postsCubit.postsIds[postIndex],
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
                        myStyle: Theme.of(context).textTheme.bodyText2),
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
                    const Icon(myIcons.like),
                    SizedBox(
                      width: Adaptive.w(2),
                    ),
                    defaultText(
                        text: '${postsCubit.likes[postIndex]}',
                        myStyle: Theme.of(context).textTheme.subtitle1),
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
                              postId: postsCubit.postsIds[postIndex],
                              postUid : post.uId,
                              index: postIndex,
                              currentUser: currentUser);
                        },
                        child: Row(
                          children: [
                            const Icon(myIcons.like),
                            SizedBox(
                              width: Adaptive.w(2.3),
                            ),
                            defaultText(
                                text: 'Like',
                                myStyle: Theme.of(context).textTheme.subtitle1),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                        child: InkWell(
                      onTap: () {
                        postsCubit.getComments(
                            postId: postsCubit.postsIds[postIndex]);
                        postsCubit.getLikedUsers(
                            postId: postsCubit.postsIds[postIndex],
                            context: context,
                            index: postIndex);
                        navigateToWithAnimation(
                            context: context,
                            nextScreen: CommentsScreen(
                              postId: postsCubit.postsIds[postIndex],
                              postIndex: postIndex,
                              postUid:post.uId,
                            ),
                            durationInMilliSecs: 300,
                            pageTransitionType: PageTransitionType.rightToLeft);
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline),
                          SizedBox(
                            width: Adaptive.w(1),
                          ),
                          defaultText(
                              text: 'Comment',
                              myStyle: Theme.of(context).textTheme.subtitle1),
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
                            const Icon(Icons.ios_share),
                            SizedBox(
                              width: Adaptive.w(1),
                            ),
                            defaultText(
                                text: 'Share',
                                myStyle: Theme.of(context).textTheme.subtitle1),
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
    },
  );
}

Widget profileData({required UserModel currentUser}) {
  return Container(
    padding: EdgeInsets.symmetric(
        horizontal: Adaptive.w(2), vertical: Adaptive.h(1.5)),
    height: Adaptive.h(43),
    child: Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Align(
          alignment: AlignmentDirectional.topCenter,
          child: Container(
            height: Adaptive.h(30),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(
                    10,
                  ),
                  topRight: Radius.circular(
                    10,
                  ),
                ),
                image: DecorationImage(
                  image: NetworkImage(currentUser.coverPhoto.toString()),
                  fit: BoxFit.cover,
                )),
          ),
        ),
        CircleAvatar(
            radius: 88.0,
            backgroundColor: Colors.white,
            child: CircleAvatar(
                radius: 85.0,
                backgroundImage: NetworkImage(
                  currentUser.profilePhoto.toString(),
                ))),
      ],
    ),
  );
}

String getTimeDifference({required String dateTime}) {
  String time = "";
  if (DateTime.now().difference(DateTime.parse(dateTime)).inSeconds == 0) {
    time = 'Just now';
  }
  if (DateTime.now().difference(DateTime.parse(dateTime)).inMinutes < 1 &&
      DateTime.now().difference(DateTime.parse(dateTime)).inSeconds > 0) {
    time = '${DateTime.now().difference(DateTime.parse(dateTime)).inSeconds}s';
  }
  if (DateTime.now().difference(DateTime.parse(dateTime)).inMinutes >= 1) {
    time = '${DateTime.now().difference(DateTime.parse(dateTime)).inMinutes}m';
  }
  if (DateTime.now().difference(DateTime.parse(dateTime)).inHours >= 1) {
    time = '${DateTime.now().difference(DateTime.parse(dateTime)).inHours}h';
  }
  if (DateTime.now().difference(DateTime.parse(dateTime)).inDays >= 1) {
    time = '${DateTime.now().difference(DateTime.parse(dateTime)).inDays}d';
  }
  if (DateTime.now().difference(DateTime.parse(dateTime)).inDays >= 1 &&
      DateTime.now().difference(DateTime.parse(dateTime)).inDays % 7 == 0) {
    time = '${(DateTime.now().difference(DateTime.parse(dateTime)).inDays / 7).floor()}w';
  }
  if (DateTime.now().difference(DateTime.parse(dateTime)).inDays >= 1 &&
      DateTime.now().difference(DateTime.parse(dateTime)).inDays % 30 == 0) {
    time = '${(DateTime.now().difference(DateTime.parse(dateTime)).inDays / 30).floor()}m';
  }
  return time;
}

Widget buildPostContainerShimmer({double width=20})=>Container(
  width: Adaptive.w(width),
  height: Adaptive.h(1),
  decoration: BoxDecoration(
    color: Colors.grey,
    borderRadius:
    BorderRadius.circular(25),
  ),
);

Widget buildPostShimmer()
{return Padding(
  padding: EdgeInsets.only(bottom: Adaptive.h(1.5)),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Adaptive.w(2),
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 25,
            ),
            SizedBox(
              width: Adaptive.w(3),
            ),
            Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
               buildPostContainerShimmer(width: 24),
                SizedBox(
                  height: Adaptive.h(.6),
                ),
                buildPostContainerShimmer(width: 13),
              ],
            ),
          ],
        ),
      ),
      SizedBox(
        height: Adaptive.h(8),
      ),
      Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceEvenly,
        children: [
          buildPostContainerShimmer(),
          buildPostContainerShimmer(),
          buildPostContainerShimmer(),
        ],
      )
    ],
  ),
);}


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
