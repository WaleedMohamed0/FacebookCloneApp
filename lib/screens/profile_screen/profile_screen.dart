import 'dart:io';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/components/constants.dart';
import 'package:social_app/cubits/posts_cubit/posts_cubit.dart';
import 'package:social_app/cubits/posts_cubit/posts_states.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_states.dart';
import 'package:social_app/models/user_data.dart';
import 'package:social_app/screens/profile_screen/edit_profile_screen.dart';

import '../../components/components.dart';
import '../posts_screen/create_new_post_screen.dart';

class ProfileScreen extends StatelessWidget {
  dynamic userModel;

  ProfileScreen({this.userModel});

  @override
  Widget build(BuildContext context) {
    var postTextController = TextEditingController();
    var userCubit = UserCubit.get(context);
    var postsCubit = PostsCubit.get(context);
    print(userModel);
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: userModel != null
              ? defaultAppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  toolbarHeight: Adaptive.h(4))
              : null,
          body: ConditionalBuilder(
            condition: userCubit.gotProfileData,
            builder: (context) {
              var currentUser = UserCubit.get(context).userLogged;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
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
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      10,
                                    ),
                                    topRight: Radius.circular(
                                      10,
                                    ),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(userModel != null
                                        ? userModel!.uId == loggedUserID
                                            ? currentUser!.coverPhoto.toString()
                                            : userModel!.coverPhoto!
                                        : currentUser!.coverPhoto.toString()),
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
                                    userModel != null
                                        ? userModel!.uId == loggedUserID
                                            ? currentUser!.profilePhoto
                                                .toString()
                                            : userModel!.profilePhoto!
                                        : currentUser!.profilePhoto.toString(),
                                  ))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Adaptive.h(1),
                    ),
                    defaultText(
                        text: userModel != null
                            ? userModel!.uId == loggedUserID
                                ? currentUser!.name!
                                : userModel!.name!
                            : currentUser!.name!,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
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
                                    Icon(
                                      Icons.apartment,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: Adaptive.w(1),
                                    ),
                                    Container(
                                        width: Adaptive.w(82),
                                        child: defaultText(
                                          text: userModel != null
                                              ? userModel!.uId == loggedUserID
                                                  ? currentUser!.education!
                                                  : userModel!.education!
                                              : currentUser!.education!,
                                          fontSize: 17,
                                          textOverflow: TextOverflow.ellipsis,
                                        )),
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
                                        text: userModel != null
                                            ? userModel!.uId == loggedUserID
                                                ? currentUser!.residence!
                                                : userModel!.residence!
                                            : currentUser!.residence!,
                                        fontSize: 17),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (userModel == null ||
                              userModel!.uId == loggedUserID)
                            SizedBox(
                              height: Adaptive.h(3),
                            ),
                          if (userModel == null ||
                              userModel!.uId == loggedUserID)
                            Center(
                              child: defaultBtnWithIcon(
                                txt: 'Edit Profile',
                                function: () {
                                  navigateTo(
                                      context: context,
                                      nextScreen: EditProfileScreen(
                                        userModel: userModel,
                                      ));
                                },
                                icon: Icons.edit,
                                BorderRadValue: 13,
                              ),
                            ),
                          if (userModel == null ||
                              userModel!.uId == loggedUserID)
                            SizedBox(
                              height: Adaptive.h(5),
                            ),
                          if (userModel == null ||
                              userModel!.uId == loggedUserID)
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
                                          currentUser!.profilePhoto!,
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
                                color: HexColor('c9ccd1'),
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
                                color: HexColor('c9ccd1'),
                                thickness: 15,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    BlocConsumer<PostsCubit, PostsStates>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        return ConditionalBuilder(
                          condition: postsCubit.gotMyPosts,
                          builder: (context) {
                            return ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return buildPost(
                                      userModel == null ||
                                              (userModel != null &&
                                                  userModel.uId == loggedUserID)
                                          ? postsCubit.myPosts[index]
                                          : postsCubit.otherUsersPosts[index],
                                      postsCubit,
                                      index,
                                      context,
                                      userCubit.userLogged!);
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                      height: Adaptive.h(2),
                                    ),
                                itemCount: userModel == null ||
                                        (userModel != null &&
                                            userModel.uId == loggedUserID)
                                    ? postsCubit.myPosts.length
                                    : postsCubit.otherUsersPosts.length);
                          },
                          fallback: (context) => Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
            fallback: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
