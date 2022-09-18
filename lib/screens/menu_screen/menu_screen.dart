import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_app/components/components.dart';
import 'package:social_app/cubits/theme_manager/theme_states.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_states.dart';
import 'package:social_app/models/menu_model.dart';
import 'package:social_app/network/cache_helper.dart';

import '../../components/constants.dart';
import '../../cubits/theme_manager/theme_cubit.dart';
import '../profile_screen/my_profile_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userCubit = UserCubit.get(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<UserCubit, UserStates>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Adaptive.w(5), vertical: Adaptive.h(2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                defaultText(
                    text: 'Menu',
                    myStyle: Theme.of(context).textTheme.headline1),
                SizedBox(
                  height: Adaptive.h(3),
                ),
                userCubit.userLogged != null
                    ? InkWell(
                        onTap: () {
                          navigateToWithAnimation(
                              context: context,
                              nextScreen: MyProfileScreen(appBar: true),
                              pageTransitionType:
                                  PageTransitionType.rightToLeft);
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                userCubit.userLogged!.profilePhoto!,
                              ),
                              radius: 25,
                            ),
                            SizedBox(
                              width: Adaptive.w(3),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Adaptive.w(73),
                                  child: defaultText(
                                      text: userCubit.userLogged!.name!,
                                      myStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            fontSize: 20,
                                          )),
                                ),
                                SizedBox(
                                  height: Adaptive.h(.5),
                                ),
                                defaultText(
                                    text: 'See your profile',
                                    fontSize: 15,
                                    textColor: Colors.grey),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Shimmer.fromColors(
                        baseColor: Colors.black,
                        highlightColor: Colors.grey,
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 25,
                            ),
                            SizedBox(
                              width: Adaptive.w(3),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: Adaptive.h(2.6),
                                  width: Adaptive.w(40),
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                SizedBox(
                                  height: Adaptive.h(1),
                                ),
                                Container(
                                  height: Adaptive.h(2),
                                  width: Adaptive.w(20),
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: Adaptive.h(1),
                ),
                Divider(
                  color: Colors.grey[600],
                ),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return buildMenuItem(
                            model: menuList[index], context: context);
                      },
                      separatorBuilder: (context, index) => SizedBox(
                            height: Adaptive.h(5.5),
                          ),
                      itemCount: menuList.length),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildMenuItem({required MenuModel model, required context}) {
    return Container(
        height: Adaptive.h(8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(23),
          boxShadow: const [
            BoxShadow(
                color: Colors.blueAccent, offset: Offset(3, 3), blurRadius: 8)
          ],
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              Adaptive.w(5), Adaptive.h(1), Adaptive.w(4), Adaptive.h(1)),
          child: InkWell(
            onTap: () async {
              if (model.darkMode!) {
                return;
              } else if (!model.signOut!) {
                navigateToWithAnimation(
                    context: context,
                    nextScreen: model.screen,
                    pageTransitionType: PageTransitionType.rightToLeft);
              } else {
                CacheHelper.signOut(context);
              }
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    model.iconData,
                    size: 24,
                  ),
                ),
                SizedBox(
                  width: Adaptive.w(4),
                ),
                defaultText(
                    text: model.text!,
                    myStyle: Theme.of(context).textTheme.bodyText2),
                const Spacer(),
                if (!model.darkMode!)
                  Icon(Icons.arrow_forward_ios,
                      size: 18, color: Theme.of(context).iconTheme.color),
                if (model.darkMode!)
                  BlocConsumer<ThemeManagerCubit, ThemeManagerStates>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      return Switch(
                          value: ThemeManagerCubit.get(context).isDark,
                          onChanged: (bool x) {
                            ThemeManagerCubit.get(context).changeTheme();
                          });
                    },
                  )
              ],
            ),
          ),
        ));
  }
}
