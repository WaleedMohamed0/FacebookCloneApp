import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/components/components.dart';
import 'package:social_app/cubits/posts_cubit/posts_cubit.dart';
import 'package:social_app/cubits/posts_cubit/posts_states.dart';
import 'package:social_app/cubits/theme_manager/theme_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';

class SearchPostsScreen extends StatelessWidget {
  const SearchPostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var postsCubit = PostsCubit.get(context);
    bool isDark = ThemeManagerCubit.get(context).isDark;
    postsCubit.searchPostsList.clear();
    return Scaffold(
      backgroundColor: isDark ? HexColor('242527') : Colors.white,
      appBar: defaultAppBar(
          backgroundColor: isDark ? HexColor('242527') : Colors.white,
          foregroundColor: Colors.black,
          title: 'Search Posts',
          textColor: isDark ? Colors.white:Colors.black,
          centerTitle: true),
      body: BlocConsumer<PostsCubit, PostsStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4.5),vertical: Adaptive.h(1.5)),
                  child: searchTextField(onChange: (String searchQuery) {
                    postsCubit.searchPosts(searchQuery: searchQuery);
                  }),
                ),
                SizedBox(
                  height: Adaptive.h(2),
                ),
                if (postsCubit.searchPostsList.isNotEmpty)
                  ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return buildPost(
                            postsCubit.searchPostsList[index],
                            postsCubit,
                            index,
                            context,
                            UserCubit
                                .get(context)
                                .userLogged!,false);
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(
                            height: Adaptive.h(2),
                          ),
                      itemCount: postsCubit.searchPostsList.length)
              ],
            ),
          );
        },
      ),
    );
  }
}
