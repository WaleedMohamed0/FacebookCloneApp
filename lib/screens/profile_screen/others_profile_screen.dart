import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/components/constants.dart';
import 'package:social_app/cubits/posts_cubit/posts_cubit.dart';
import 'package:social_app/cubits/posts_cubit/posts_states.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';

import '../../components/components.dart';
import '../../cubits/theme_manager/theme_cubit.dart';
import '../posts_screen/create_new_post_screen.dart';

class OthersProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userCubit = UserCubit.get(context);
    var postsCubit = PostsCubit.get(context);
    bool isDark = ThemeManagerCubit.get(context).isDark;

    return BlocConsumer<PostsCubit, PostsStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(
              toolbarHeight: Adaptive.h(4.5)),
          body: ConditionalBuilder(
            condition: postsCubit.userClickedData != null,
            builder: (context) {
              var currentUser = postsCubit.userClickedData;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    profileData(currentUser: currentUser!),
                    SizedBox(
                      height: Adaptive.h(1),
                    ),
                    defaultText(
                        text: currentUser.name!,
                        myStyle: Theme.of(context).textTheme.headline2),
                    SizedBox(
                      height: Adaptive.h(2),
                    ),
                    Divider(
                      color: Colors.grey[600],
                      height: 2,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Adaptive.h(3)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: Adaptive.w(3)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.apartment,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: Adaptive.w(1),
                                    ),
                                    SizedBox(
                                        width: Adaptive.w(82),
                                        child: defaultText(
                                            text: currentUser.education!,
                                            myStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    overflow: TextOverflow
                                                        .ellipsis))),
                                  ],
                                ),
                                SizedBox(
                                  height: Adaptive.h(1),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.home_outlined,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: Adaptive.w(1),
                                    ),
                                    defaultText(
                                        text: currentUser.residence!,
                                        myStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (currentUser.uId == loggedUserID)
                            SizedBox(
                              height: Adaptive.h(5),
                            ),
                          if (currentUser.uId == loggedUserID)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Adaptive.w(3)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          currentUser.profilePhoto!,
                                        ),
                                        radius: 25,
                                      ),
                                      SizedBox(
                                        width: Adaptive.w(3),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          onTap: () {
                                            navigateToWithAnimation(
                                                context: context,
                                                nextScreen: CreateNewPost(),
                                                durationInMilliSecs: 500,
                                                pageTransitionType:
                                                    PageTransitionType
                                                        .bottomToTop);
                                          },
                                          decoration: InputDecoration(
                                              hintText: 'What\'s on your mind?',
                                              hintStyle: Theme.of(context).textTheme.headline5,
                                              border: InputBorder.none),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Adaptive.h(2),
                                  ),
                                  Divider(
                                    color: Colors.grey[600],
                                    height: 2,
                                  ),
                                  SizedBox(
                                    height: Adaptive.h(.5),
                                  ),
                                  Container(
                                    height: Adaptive.h(4),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Adaptive.w(3)),
                                    child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) =>
                                            InkWell(
                                              onTap: () {
                                                if (index == 1) {
                                                  navigateToWithAnimation(
                                                      context: context,
                                                      nextScreen:
                                                          CreateNewPost(),
                                                      durationInMilliSecs: 500,
                                                      pageTransitionType:
                                                          PageTransitionType
                                                              .bottomToTop);
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    postsAdditionList[index]
                                                        .iconData,
                                                    color:
                                                        postsAdditionList[index]
                                                            .iconColor,
                                                  ),
                                                  SizedBox(
                                                    width: Adaptive.w(1.3),
                                                  ),
                                                  defaultText(
                                                      text: postsAdditionList[
                                                              index]
                                                          .text)
                                                ],
                                              ),
                                            ),
                                        separatorBuilder: (context, index) =>
                                            IntrinsicHeight(
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: Adaptive.w(3.82),
                                                  ),
                                                  VerticalDivider(
                                                      thickness: 1,
                                                      width: 20,
                                                      indent: 7,
                                                      color: Colors.grey[400]),
                                                  SizedBox(
                                                    width: Adaptive.w(3.82),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        itemCount: postsAdditionList.length),
                                  )
                                ],
                              ),
                            ),
                          SizedBox(
                            height: Adaptive.h(3),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(
                                color:isDark ? Colors.black : HexColor('c9ccd1'),
                                thickness: 15,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Adaptive.h(1),
                                    horizontal: Adaptive.w(3)),
                                child: defaultText(
                                    text: "Posts",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.5),
                              ),
                              Divider(
                                color: isDark ? Colors.black : HexColor('c9ccd1'),
                                thickness: 15,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (postsCubit.userClickedPosts.isNotEmpty)
                      ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return buildPost(
                                postsCubit.userClickedPosts[index],
                                postsCubit,
                                index,
                                context,
                                userCubit.userLogged!);
                          },
                          separatorBuilder: (context, index) => SizedBox(
                                height: Adaptive.h(2),
                              ),
                          itemCount: postsCubit.userClickedPosts.length)
                  ],
                ),
              );
            },
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
