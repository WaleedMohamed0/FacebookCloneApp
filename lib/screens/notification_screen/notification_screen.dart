import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/cubits/posts_cubit/posts_cubit.dart';
import 'package:social_app/cubits/posts_cubit/posts_states.dart';
import 'package:social_app/models/notification_model.dart';
import 'package:social_app/my_flutter_app_icons.dart';
import 'package:social_app/screens/notification_screen/notification_post_screen.dart';

import '../../components/components.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var postsCubit = PostsCubit.get(context);
    return Scaffold(
      body: BlocConsumer<PostsCubit, PostsStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (postsCubit.notificationsList.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Adaptive.w(5), vertical: Adaptive.h(2)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    defaultText(
                        text: 'Notifications',
                        myStyle: Theme.of(context).textTheme.headline1),
                    ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return buildNotification(
                              notification: postsCubit.notificationsList[index],
                              context: context,
                              index: index,
                              postsCubit: postsCubit);
                        },
                        separatorBuilder: (context, index) => SizedBox(
                              height: Adaptive.h(3),
                            ),
                        itemCount: postsCubit.notificationsList.length),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: defaultText(
                text: 'No Notifications Yet...',
                fontSize: 23,
                fontStyle: FontStyle.italic,
                wordSpacing: 2),
          );
        },
      ),
    );
  }

  Widget buildNotification(
      {required NotificationModel notification,
      required context,
      required int index,
      required PostsCubit postsCubit}) {
    String notificationText = notification.type == "like"
        ? "liked your post"
        : "commented on your post";
    return InkWell(
      onTap: () {
        postsCubit.getNotificationPostData(postId: notification.postId);
        navigateToWithAnimation(
            context: context,
            nextScreen: NotificationPostScreen(),
            pageTransitionType: PageTransitionType.rightToLeft);
      },
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  notification.profilePhoto,
                ),
                radius: 34,
              ),
              notification.type == "like"
                  ? const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 13,
                      child: CircleAvatar(
                        radius: 12,
                        child: Icon(
                          myIcons.like,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    )
                  : const CircleAvatar(
                      radius: 13,
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.mode_comment,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
            ],
          ),
          SizedBox(
            width: Adaptive.w(3),
          ),
          SizedBox(
            width: Adaptive.w(69),
            child: RichText(
              text: TextSpan(
                  text: "${notification.name} ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 22),
                  children: [
                    TextSpan(
                        text: notificationText,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 20)),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
