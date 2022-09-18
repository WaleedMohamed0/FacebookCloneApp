import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/components/components.dart';
import 'package:social_app/cubits/posts_cubit/posts_cubit.dart';
import 'package:social_app/cubits/theme_manager/theme_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/models/comment_model.dart';

import 'package:social_app/my_flutter_app_icons.dart';
import 'package:social_app/screens/posts_screen/people_who_reacted_screen.dart';

import '../../cubits/posts_cubit/posts_states.dart';
import '../profile_screen/others_profile_screen.dart';

class CommentsScreen extends StatelessWidget {
  String postId = "";
  String postUid = "";
  int postIndex = 0;

  CommentsScreen({super.key, required this.postId, required this.postIndex,required this.postUid});

  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();
    var postsCubit = PostsCubit.get(context);
    var userCubit = UserCubit.get(context);
    bool isDark = ThemeManagerCubit.get(context).isDark;
    ScrollController scrollController =
        ScrollController(initialScrollOffset: Adaptive.h(20000));
    return BlocConsumer<PostsCubit, PostsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: EdgeInsets.only(left: Adaptive.w(3.6)),
              child: Row(
                children: [
                  const Icon(
                    myIcons.like,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: Adaptive.w(2),
                  ),
                  defaultText(
                    text: '${postsCubit.likes[postIndex]}',
                    myStyle: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 14),
                  )
                ],
              ),
            ),
            title: postsCubit.usersLikedData.isNotEmpty
                ? InkWell(
                    onTap: () {
                      navigateToWithAnimation(
                          context: context,
                          nextScreen: const PeopleWhoReactedScreen(),
                          pageTransitionType: PageTransitionType.rightToLeft);
                    },
                    child: Row(
                      children: [
                        defaultText(
                            textColor: Colors.black,
                            text: postsCubit.usersLikedData[0].name,
                            myStyle: Theme.of(context).textTheme.bodyText1),
                        if (postsCubit.usersLikedData.length > 1 &&
                            postsCubit.usersLikedData.length != 2)
                          SizedBox(
                            width: Adaptive.w(23),
                            child: defaultText(
                                text:
                                    ' and ${postsCubit.usersLikedData.length - 1} others',
                                myStyle: Theme.of(context).textTheme.bodyText1),
                          ),
                        if (postsCubit.usersLikedData.length == 2)
                          SizedBox(
                            width: Adaptive.w(23),
                            child: defaultText(
                                text:
                                    ' and ${postsCubit.usersLikedData.length - 1} other',
                                myStyle: Theme.of(context).textTheme.bodyText1),
                          ),
                        SizedBox(
                          width: Adaptive.w(1.5),
                        ),
                        const Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  )
                : Container(),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.separated(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        horizontal: Adaptive.w(4), vertical: Adaptive.h(3)),
                    itemBuilder: (context, index) {
                      return buildComment(
                          commentData: postsCubit.comments[index],
                          userCubit: userCubit,
                          index: index,
                          context: context);
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          height: Adaptive.h(3),
                        ),
                    itemCount: postsCubit.comments.length),
              ),
              Divider(
                color: Colors.grey[600],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: Adaptive.w(3),
                    right: Adaptive.w(3),
                    bottom: Adaptive.h(.5)),
                child: Row(
                  children: [
                    Flexible(
                      child: Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: defaultTextField(
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          textInput: TextInputType.text,
                          hintStyle: const TextStyle(color: Colors.grey),
                          hintText: 'Write a comment...',
                          fillColor:
                              isDark ? HexColor('242527') : Colors.transparent,
                          contentPadding: 10,
                          borderRadius: 30,
                          borderColor:
                              isDark ? Colors.transparent : Colors.white,
                          controller: commentController,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Adaptive.w(3),
                    ),
                    defaultIconButton(
                        icon: Icons.send_sharp,
                        onPressed: () {
                          if (scrollController.hasClients &&
                              scrollController.position.maxScrollExtent > 0) {
                            scrollController.animateTo(
                                scrollController.position.maxScrollExtent +
                                    Adaptive.h(8),
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut);
                          }

                          postsCubit.addNewComment(
                              postId: postsCubit.postsIds[postIndex],
                              commentText: commentController.text,
                              postUid:postUid,
                              currentUser: userCubit.userLogged!);
                          commentController.clear();
                        },
                        constraints: const BoxConstraints(),
                        size: 26)
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildComment(
      {required CommentModel commentData,
      required UserCubit userCubit,
      required int index,
      required context}) {
    RegExp exp = RegExp("[a-zA-Z]");
    String time = getTimeDifference(dateTime: commentData.dateTime);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            PostsCubit.get(context).getUserClickedData(uId: commentData.uId);
            navigateToWithAnimation(
                context: context,
                nextScreen: OthersProfileScreen(),
                pageTransitionType: PageTransitionType.rightToLeft);
          },
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              commentData.profilePhoto,
            ),
            radius: 25,
          ),
        ),
        SizedBox(
          width: Adaptive.w(1.5),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ThemeManagerCubit.get(context).isDark
                    ? HexColor('333436')
                    : Colors.grey[200],
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: Adaptive.w(3), vertical: Adaptive.h(.9)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      PostsCubit.get(context).getUserClickedData(
                        uId: commentData.uId,
                      );
                      navigateToWithAnimation(
                          context: context,
                          nextScreen: OthersProfileScreen(),
                          pageTransitionType: PageTransitionType.rightToLeft);
                    },
                    child: defaultText(
                        text: commentData.name,
                        myStyle: Theme.of(context).textTheme.bodyText1),
                  ),
                  SizedBox(
                    height: Adaptive.h(1),
                  ),
                  SizedBox(
                    width: Adaptive.w(70),
                    child: defaultText(
                        text: commentData.commentText,
                        textAlign: exp.hasMatch(commentData.commentText)
                            ? TextAlign.start
                            : TextAlign.end,
                        myStyle: Theme.of(context).textTheme.headline5),
                  )
                ],
              ),
            ),
            SizedBox(
              height: Adaptive.h(.5),
            ),
            Padding(
              padding: EdgeInsets.only(left: Adaptive.w(3)),
              child: defaultText(text: time,myStyle: Theme.of(context).textTheme.subtitle2),
            )
          ],
        ),
      ],
    );
  }
}
