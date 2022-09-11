import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/cubits/posts_cubit/posts_cubit.dart';
import 'package:social_app/cubits/posts_cubit/posts_states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_data.dart';
import 'package:social_app/my_flutter_app_icons.dart';
import 'package:social_app/screens/profile_screen/profile_screen.dart';

import '../../components/components.dart';

class UsersWhoReactedScreen extends StatelessWidget {
  const UsersWhoReactedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var postsCubit = PostsCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: defaultAppBar(
        title: 'People who reacted',
        textColor: Colors.black,
        backgroundColor: Colors.white,
        fontSize: 17,
        elevation: 0,
        leading: defaultIconButton(
            icon: Icons.arrow_back,
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
            size: 30,
            padding: EdgeInsets.only(left: Adaptive.w(2))),
        // to add divider at the end of app bar
        preferredSizeWidget: PreferredSize(
            child: Divider(
              color: Colors.grey[600],
            ),
            preferredSize: Size.fromHeight(1)),
        actions: [
          defaultIconButton(
              icon: Icons.search, onPressed: () {}, color: Colors.black)
        ],
      ),
      body: BlocConsumer<PostsCubit, PostsStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                    // controller: scrollController,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        horizontal: Adaptive.w(4), vertical: Adaptive.h(3)),
                    itemBuilder: (context, index) {
                      return buildUserWhoLikedPost(
                          model: postsCubit.usersLiked[index],
                          context: context,
                          postsCubit: postsCubit);
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          height: Adaptive.h(3),
                        ),
                    itemCount: postsCubit.usersLiked.length),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildUserWhoLikedPost(
      {required UserModel model,
      required context,
      required PostsCubit postsCubit}) {
    return InkWell(
      onTap: () {
        postsCubit.getOtherUsersPosts(uId: model.uId!);
        navigateToWithAnimation(
            context: context,
            nextScreen: ProfileScreen(userModel: model),
            pageTransitionType: PageTransitionType.rightToLeft);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  model.profilePhoto!,
                ),
                radius: 34,
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: CircleAvatar(
                  child: Icon(
                    myIcons.like,
                    color: Colors.white,
                    size: 14,
                  ),
                  radius: 13,
                ),
              ),
            ],
          ),
          SizedBox(
            width: Adaptive.w(3),
          ),
          defaultText(
              text: model.name!, fontWeight: FontWeight.bold, fontSize: 19),
        ],
      ),
    );
  }
}
