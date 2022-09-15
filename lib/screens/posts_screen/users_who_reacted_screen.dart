import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/cubits/posts_cubit/posts_cubit.dart';
import 'package:social_app/cubits/posts_cubit/posts_states.dart';
import 'package:social_app/models/like_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_data.dart';
import 'package:social_app/my_flutter_app_icons.dart';
import 'package:social_app/screens/profile_screen/my_profile_screen.dart';

import '../../components/components.dart';
import '../../cubits/theme_manager/theme_cubit.dart';
import '../profile_screen/others_profile_screen.dart';

class UsersWhoReactedScreen extends StatelessWidget {
  const UsersWhoReactedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var postsCubit = PostsCubit.get(context);
    bool isDark = ThemeManagerCubit.get(context).isDark;

    return Scaffold(
      appBar: defaultAppBar(
        title: 'People who reacted',
        leading: defaultIconButton(
            icon: Icons.arrow_back,
            onPressed: () {
              Navigator.pop(context);
            },
            color: Theme.of(context).iconTheme.color!,
            size: 28,
            padding: EdgeInsets.only(left: Adaptive.w(2))),
        // to add divider at the end of app bar
        preferredSizeWidget: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              color: Colors.grey[600],
            )),
        actions: [
          defaultIconButton(
              icon: Icons.search,
              onPressed: () {},
              color: isDark ? Colors.white : Colors.black)
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
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        horizontal: Adaptive.w(4), vertical: Adaptive.h(3)),
                    itemBuilder: (context, index) {
                      return buildUserWhoLikedPost(
                          model: postsCubit.usersLikedData[index],
                          context: context,
                          postsCubit: postsCubit);
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          height: Adaptive.h(3),
                        ),
                    itemCount: postsCubit.usersLikedData.length),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildUserWhoLikedPost(
      {required LikeModel model,
      required context,
      required PostsCubit postsCubit}) {
    return InkWell(
      onTap: () {
        postsCubit.getUserClickedData(
          uId: model.uId,
        );
        navigateToWithAnimation(
            context: context,
            nextScreen: OthersProfileScreen(),
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
                  model.profilePhoto,
                ),
                radius: 34,
              ),
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: CircleAvatar(
                  radius: 13,
                  child: Icon(
                    myIcons.like,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: Adaptive.w(3),
          ),
          defaultText(
              text: model.name,
              myStyle: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 20)),
        ],
      ),
    );
  }
}
