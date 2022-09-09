import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/components/components.dart';
import 'package:social_app/cubits/posts_cubit/cubit.dart';
import 'package:social_app/cubits/user_cubit/cubit.dart';
import 'package:social_app/cubits/user_cubit/states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/my_flutter_app_icons.dart';
import 'package:social_app/screens/posts_screen/create_new_post_screen.dart';

import '../../cubits/posts_cubit/states.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var postsCubit = PostsCubit.get(context);
    var userCubit = UserCubit.get(context);
    return BlocConsumer<PostsCubit, PostsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: ConditionalBuilder(
            condition: postsCubit.gotAllPosts &&
                postsCubit.likes.isNotEmpty &&
                UserCubit.get(context).userLogged!.profilePhoto != "",
            builder: (context) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Adaptive.w(2), vertical: Adaptive.h(2)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: Adaptive.w(1.6)),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                UserCubit.get(context)
                                    .userLogged!
                                    .profilePhoto!,
                              ),
                              radius: 25,
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
                                Navigator.of(context, rootNavigator: true)
                                    .push(PageTransition(
                                        // alignment: Alignment.center,
                                        child: CreateNewPost(),
                                        type: PageTransitionType.rightToLeft));
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: Adaptive.h(2.5),
                      ),
                      ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return buildPost(postsCubit.allPosts[index],
                                postsCubit, index, context,userCubit.userLogged!);
                          },
                          separatorBuilder: (context, index) => SizedBox(
                                height: Adaptive.h(2),
                              ),
                          itemCount: postsCubit.allPosts.length),
                    ],
                  ),
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
