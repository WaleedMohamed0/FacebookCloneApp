import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/components/components.dart';
import 'package:social_app/cubits/posts_cubit/posts_cubit.dart';
import 'package:social_app/cubits/posts_cubit/posts_cubit.dart';
import 'package:social_app/cubits/theme_manager/theme_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_states.dart';
import 'package:social_app/my_flutter_app_icons.dart';

import '../../components/constants.dart';
import '../../cubits/posts_cubit/posts_states.dart';
import '../home_screen/home_screen.dart';

class CreateNewPost extends StatelessWidget {
  const CreateNewPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var postTextController = TextEditingController();
    var postsCubit = PostsCubit.get(context);
    var userCubit = UserCubit.get(context);
    bool isDark = ThemeManagerCubit.get(context).isDark;
    return BlocConsumer<PostsCubit, PostsStates>(
      listener: (context, state) {
        if (state is CreateNewPostSuccessState) {
          defaultToast(msg: "Post Added Successfully");

          postsCubit.getAllPosts().then((value) {
            Navigator.pop(context);
          });
        } else if (state is CreateNewPostErrorState) {
          defaultToast(
              msg: "Error In Uploading Your Post", backgroundColor: Colors.red);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: isDark ? HexColor('242527') : Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: defaultAppBar(
              title: "Create Post",
              backgroundColor:isDark ? HexColor('242527') : Colors.white,
              foregroundColor: Colors.black,
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Adaptive.w(2.8), vertical: Adaptive.h(1.3)),
                  child: defaultBtn(
                      txt: "POST",
                      function: () {
                        if (postsCubit.postImagePath != null) {
                          postsCubit.uploadPostImage(
                              text: postTextController.text,
                              currentUser: userCubit.userLogged!);
                        } else {
                          postsCubit.createNewPost(
                              text: postTextController.text,
                              currentUser: userCubit.userLogged!);
                        }
                      },
                      width: 80,
                      borderRadius: 7,
                      fontSize: 15,
                      borderWidth: 0),
                )
              ]),
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Adaptive.h(2),
                      ),
                      if (state is CreateNewPostLoadingState ||
                          state is UploadPostImageLoadingState)
                        SizedBox(
                          height: Adaptive.h(1),
                        ),
                      if (state is CreateNewPostLoadingState ||
                          state is UploadPostImageLoadingState)
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: Adaptive.w(3)),
                          child: LinearProgressIndicator(),
                        ),
                      if (state is CreateNewPostLoadingState ||
                          state is UploadPostImageLoadingState)
                        SizedBox(
                          height: Adaptive.h(1.6),
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              userCubit.userLogged!.profilePhoto!,
                            ),
                            radius: 25,
                          ),
                          SizedBox(
                            width: Adaptive.w(3.3),
                          ),
                          defaultText(
                              text: userCubit.userLogged!.name!,
                              fontSize: 22.5,
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                      SizedBox(
                        height: Adaptive.h(2.5),
                      ),
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: postTextController,
                          decoration: InputDecoration(
                              hintText: 'What\'s on your mind?',
                              hintStyle: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 20),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 18),
                              border: InputBorder.none),
                        ),
                      ),
                      if (postsCubit.postImagePath != null)
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              height: Adaptive.h(27),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(
                                          postsCubit.postImagePath!))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: Adaptive.w(4.5), top: Adaptive.h(.8)),
                              child: CircleAvatar(
                                  child: defaultIconButton(
                                      icon: Icons.close,
                                      color: Colors.white,
                                      onPressed: () {
                                        postsCubit.removePostImage();
                                      })),
                            )
                          ],
                        ),
                      SizedBox(
                        height: Adaptive.h(2),
                      ),
                      Divider(
                        color: Colors.grey[600],
                        indent: 10,
                      ),
                      InkWell(
                        onTap: () {
                          postsCubit.getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: Adaptive.w(1)),
                              child: Icon(
                                Icons.image,
                                color: Colors.green,
                                size: 35,
                              ),
                            ),
                            SizedBox(
                              width: Adaptive.w(1),
                            ),
                            defaultText(text: "Photo", fontSize: 20)
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey[600],
                        indent: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
