import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/components/components.dart';
import 'package:social_app/cubits/posts_cubit/posts_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/my_flutter_app_icons.dart';
import 'package:social_app/screens/posts_screen/create_new_post_screen.dart';

import '../../cubits/posts_cubit/posts_states.dart';
import '../profile_screen/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var postsCubit = PostsCubit.get(context);
    var userCubit = UserCubit.get(context);
    return BlocConsumer<PostsCubit, PostsStates>(
      listener: (context, state) {
        if (state is SharePostSuccessState) {
          defaultToast(msg: 'You Shared this Post');
          postsCubit.getAllPosts();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: Adaptive.h(2)),
              child: Column(
                children: [
                  BlocConsumer<UserCubit, UserStates>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      return Row(
                        children: [
                          if (UserCubit.get(context).userLogged != null &&
                              UserCubit.get(context).userLogged!.profilePhoto !=
                                  "")
                            Padding(
                              padding: EdgeInsets.only(left: Adaptive.w(2)),
                              child: InkWell(
                                onTap: () {
                                  navigateToWithAnimation(
                                      context: context,
                                      nextScreen: ProfileScreen(
                                          userModel: userCubit.userLogged),
                                      pageTransitionType:
                                          PageTransitionType.rightToLeft);
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    UserCubit.get(context)
                                        .userLogged!
                                        .profilePhoto!,
                                  ),
                                  radius: 25,
                                ),
                              ),
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
                                      PageTransitionType.bottomToTop);
                            },
                            decoration: InputDecoration(
                                hintText: 'What\'s on your mind?',
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                )),
                          )),
                          Padding(
                            padding: EdgeInsets.only(left: Adaptive.w(1)),
                            child: IconButton(
                              icon: Icon(Icons.image,
                                  color: Colors.green, size: 28),
                              onPressed: () {
                                navigateToWithAnimation(
                                    context: context,
                                    nextScreen: CreateNewPost(),
                                    pageTransitionType:
                                        PageTransitionType.rightToLeft);
                              },
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: Adaptive.h(2.5),
                  ),
                  if (postsCubit.allPosts.isNotEmpty)
                    ConditionalBuilder(
                      condition:
                          postsCubit.gotAllPosts && postsCubit.likes.isNotEmpty,
                      builder: (context) {
                        return ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return buildPost(
                                  postsCubit.allPosts[index],
                                  postsCubit,
                                  index,
                                  context,
                                  userCubit.userLogged!);
                            },
                            separatorBuilder: (context, index) => SizedBox(
                                  height: Adaptive.h(2),
                                ),
                            itemCount: postsCubit.allPosts.length);
                      },
                      fallback: (context) => Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
