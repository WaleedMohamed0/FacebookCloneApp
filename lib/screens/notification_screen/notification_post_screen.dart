import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/components/components.dart';
import 'package:social_app/cubits/posts_cubit/posts_cubit.dart';
import 'package:social_app/cubits/posts_cubit/posts_states.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';

class NotificationPostScreen extends StatelessWidget {
  const NotificationPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var postsCubit = PostsCubit.get(context);
    return Scaffold(
      appBar: defaultAppBar(),
      body: BlocBuilder<PostsCubit, PostsStates>(
        builder: (context, state) {
          return buildPost(
              postsCubit.notificationPostData!,
              postsCubit,
              postsCubit.postIndex,
              context,
              UserCubit.get(context).userLogged!);
        },
      ),
    );
  }
}
