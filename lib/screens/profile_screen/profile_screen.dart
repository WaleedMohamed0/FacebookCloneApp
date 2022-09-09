import 'dart:io';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/components/constants.dart';
import 'package:social_app/cubits/posts_cubit/cubit.dart';
import 'package:social_app/cubits/posts_cubit/states.dart';
import 'package:social_app/cubits/user_cubit/cubit.dart';
import 'package:social_app/cubits/user_cubit/states.dart';
import 'package:social_app/screens/profile_screen/edit_profile_screen.dart';

import '../../components/components.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var postTextController = TextEditingController();
    var userCubit = UserCubit.get(context);
    var postsCubit = PostsCubit.get(context);

    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: ConditionalBuilder(
            condition: userCubit.gotProfileData,
            builder: (context) {
              var userModel = UserCubit.get(context).userLogged;
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
                                    image: NetworkImage(
                                        userModel!.coverPhoto.toString()),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                          CircleAvatar(
                              radius: 88.0,
                              child: CircleAvatar(
                                  radius: 85.0,
                                  backgroundImage: NetworkImage(
                                    userModel.profilePhoto.toString(),
                                  ))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Adaptive.h(1),
                    ),
                    defaultText(
                        text: userModel.name!,
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
                      padding: EdgeInsets.symmetric(
                          horizontal: Adaptive.w(4), vertical: Adaptive.h(3)),
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
                                    text: userModel.education!,
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
                                  text: userModel.residence!, fontSize: 17),
                            ],
                          ),
                          SizedBox(
                            height: Adaptive.h(2),
                          ),
                          defaultBtnWithIcon(
                            txt: 'Edit Profile',
                            function: () {
                              navigateTo(
                                  context: context,
                                  nextScreen: EditProfileScreen());
                            },
                            icon: Icons.edit,
                            BorderRadValue: 13,
                          ),
                          SizedBox(
                            height: Adaptive.h(3),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              defaultText(
                                  text: 'Posts',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              SizedBox(
                                height: Adaptive.h(3),
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      userModel.profilePhoto!,
                                    ),
                                    radius: 25,
                                  ),
                                  SizedBox(
                                    width: Adaptive.w(2),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {},
                                      child: TextFormField(
                                        controller: postTextController,
                                        decoration: InputDecoration(
                                            hintText: 'What\'s on your mind?',
                                            border: InputBorder.none),
                                      ),
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
                                    itemBuilder: (context, index) => InkWell(
                                          onTap: () {
                                            postsAdditionList[index].onPressed;
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                postsAdditionList[index]
                                                    .iconData,
                                                color: postsAdditionList[index]
                                                    .iconColor,
                                              ),
                                              SizedBox(
                                                width: Adaptive.w(1),
                                              ),
                                              defaultText(
                                                  text: postsAdditionList[index]
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
                          )
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
                                      postsCubit.myPosts[index],
                                      postsCubit,
                                      index,
                                      context,
                                      userCubit.userLogged!);
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                      height: Adaptive.h(2),
                                    ),
                                itemCount: postsCubit.myPosts.length);
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
