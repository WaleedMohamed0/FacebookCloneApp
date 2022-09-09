import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/components/components.dart';
import 'package:social_app/components/constants.dart';
import 'package:social_app/cubits/posts_cubit/cubit.dart';
import 'package:social_app/cubits/user_cubit/cubit.dart';

import 'package:social_app/my_flutter_app_icons.dart';

import '../../cubits/posts_cubit/states.dart';

class CommentsScreen extends StatelessWidget {
  String postId = "";
  int postIndex = 0;

  CommentsScreen({required this.postId, required this.postIndex});

  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();
    var postsCubit = PostsCubit.get(context);
    var userCubit = UserCubit.get(context);
    ScrollController scrollController =
        ScrollController(initialScrollOffset: Adaptive.h(20000));
    return BlocConsumer<PostsCubit, PostsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            leading: Padding(
              padding: EdgeInsets.only(left: Adaptive.w(3.6)),
              child: Row(
                children: [
                  Icon(
                    myIcons.like,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: Adaptive.w(2),
                  ),
                  defaultText(
                      text: '${postsCubit.likes[postIndex]}',
                      textColor: Colors.black)
                ],
              ),
            ),
            title: Row(
              children: [
                defaultText(
                    textColor: Colors.black,
                    text: postsCubit.usersLikedPost[0].name!),
                if (postsCubit.usersLikedPost.length > 1 &&
                    postsCubit.usersLikedPost.length != 2)
                  defaultText(
                      text:
                          ' and ${postsCubit.usersLikedPost.length - 1} others'),
                if(postsCubit.usersLikedPost.length == 2)
                  defaultText(
                      text:
                      ' and ${postsCubit.usersLikedPost.length - 1} other'),
                SizedBox(
                  width: Adaptive.w(1.5),
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.separated(
                    controller: scrollController,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        horizontal: Adaptive.w(4), vertical: Adaptive.h(3)),
                    itemBuilder: (context, index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              // check if profilePhoto is updated so it can be updated in comments asWell
                              postsCubit.comments[index].uId == loggedUserID
                                  ? userCubit.userLogged!.profilePhoto!
                                  : postsCubit.comments[index].profilePhoto,
                            ),
                            radius: 25,
                          ),
                          SizedBox(
                            width: Adaptive.w(3),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[200],
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: Adaptive.w(3),
                                vertical: Adaptive.h(.9)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                defaultText(
                                    // check if name is updated so it can be updated in comments asWell
                                    text: postsCubit.comments[index].uId ==
                                            loggedUserID
                                        ? userCubit.userLogged!.name!
                                        : postsCubit.comments[index].name,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                SizedBox(
                                  height: Adaptive.h(1),
                                ),
                                SizedBox(
                                  width: Adaptive.w(67),
                                  child: defaultText(
                                    text:
                                        postsCubit.comments[index].commentText,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
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
                padding: EdgeInsets.symmetric(horizontal: Adaptive.w(3)),
                child: Row(
                  children: [
                    Flexible(
                      child: Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: defaultTextField(
                          textInput: TextInputType.text,
                          hintText: 'Write a comment...',
                          fillColor: Colors.grey[100]!,
                          contentPadding: 23,
                          borderRadius: 30,
                          controller: commentController,
                        ),
                      ),
                    ),
                    defaultIconButton(
                        icon: Icons.send_sharp,
                        onPressed: () {
                          if (scrollController.hasClients &&
                              scrollController.position.maxScrollExtent > 0) {
                            scrollController.animateTo(
                                scrollController.position.maxScrollExtent +
                                    Adaptive.h(8),
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOut);
                          }

                          postsCubit.addNewComment(
                              postId: postsCubit.postsId[postIndex],
                              commentText: commentController.text,
                              userCubit: userCubit);
                          commentController.clear();
                        },
                        constraints: BoxConstraints(),
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
}
