import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/cubits/chats_cubit/chats_cubit.dart';
import 'package:social_app/cubits/posts_cubit/posts_cubit.dart';
import 'package:social_app/cubits/theme_manager/theme_cubit.dart';
import 'package:social_app/cubits/theme_manager/theme_states.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_states.dart';
import 'package:social_app/screens/chats/messenger_screen.dart';
import 'package:social_app/screens/menu_screen/menu_screen.dart';
import 'package:social_app/screens/posts_screen/search_posts_screen.dart';

import '../../components/components.dart';
import '../../components/constants.dart';
import '../../styles/theme_data.dart';
import '../home_screen/home_screen.dart';
import '../notification_screen/notification_screen.dart';
import '../profile_screen/my_profile_screen.dart';

class StartUpScreen extends StatefulWidget {
  const StartUpScreen({Key? key}) : super(key: key);

  @override
  State<StartUpScreen> createState() => _StartUpScreenState();
}

class _StartUpScreenState extends State<StartUpScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 4);
    tabController!.addListener(() {
      setState(() {});
    });
  }

  // @override
  // void dispose() {
  //   tabController!.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeManagerCubit, ThemeManagerStates>(
      builder: (context, state) {
        bool isDark = ThemeManagerCubit.get(context).isDark;
        final List<Tab> myTabs = [
          Tab(
              icon: Icon(
            Icons.home,
            size: 28,
            color: tabController!.index == 0 ? defaultColor : Colors.grey[500],
          )),
          Tab(
              icon: Icon(
            Icons.person,
            size: 28,
            color: tabController!.index == 1 ? defaultColor : Colors.grey[500],
          )),
          Tab(
              icon: Icon(
            Icons.notifications,
            size: 28,
            color: tabController!.index == 2 ? defaultColor : Colors.grey[500],
          )),
          Tab(
              icon: Icon(
            Icons.menu,
            size: 28,
            color: tabController!.index == 3 ? defaultColor : Colors.grey[500],
          ))
        ];

        return DefaultTabController(
            length: 4,
            initialIndex: 0,
            child: Column(
              children: [
                SizedBox(
                  height: Adaptive.h(18),
                  child: AppBar(
                    title: defaultText(
                        text: "facebook",
                        textColor: Colors.blue,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                    actions: [
                      CircleAvatar(
                        backgroundColor:
                            isDark ? HexColor('393a3c') : HexColor('f1f2f6'),
                        child: IconButton(
                          onPressed: () {
                            navigateToWithAnimation(
                                context: context,
                                nextScreen: const SearchPostsScreen(),
                                pageTransitionType:
                                    PageTransitionType.rightToLeft);
                          },
                          icon: Icon(
                            Icons.search,
                            color: isDark ? Colors.white : Colors.black,
                            size: 27,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
                        child: InkWell(
                          hoverColor: transparentColor,
                          splashColor: transparentColor,
                          focusColor: transparentColor,
                          highlightColor: transparentColor,
                          onTap: () {
                            ChatsCubit.get(context).getLastMessages(context);
                            navigateToWithAnimation(
                                context: context,
                                nextScreen: const MessengerScreen(),
                                durationInMilliSecs: 500,
                                pageTransitionType:
                                    PageTransitionType.rightToLeft);
                          },
                          child: CircleAvatar(
                              backgroundColor: isDark
                                  ? HexColor('393a3c')
                                  : HexColor('f1f2f6'),
                              radius: 20,
                              child: Image.asset(
                                'assets/images/messanger.png',
                                width: 27,
                              )),
                        ),
                      ),
                    ],
                    backgroundColor: isDark ? HexColor('242527') : Colors.white,
                    bottom: TabBar(
                        indicator: UnderlineTabIndicator(
                            borderSide: const BorderSide(width: 3.0),
                            insets: EdgeInsets.symmetric(
                                horizontal: Adaptive.w(4.2))),
                        indicatorColor: defaultColor,
                        controller: tabController,
                        tabs: myTabs),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      MaterialApp(
                        home: HomeScreen(),
                        theme: lightMode,
                        darkTheme: darkMode,
                        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                        debugShowCheckedModeBanner: false,
                      ),
                      MaterialApp(
                        home: MyProfileScreen(),
                        theme: lightMode,
                        darkTheme: darkMode,
                        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                        debugShowCheckedModeBanner: false,
                      ),
                      MaterialApp(
                        home: NotificationsScreen(),
                        theme: lightMode,
                        darkTheme: darkMode,
                        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                        debugShowCheckedModeBanner: false,
                      ),
                      MaterialApp(
                        home: MenuScreen(),
                        theme: lightMode,
                        darkTheme: darkMode,
                        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                        debugShowCheckedModeBanner: false,
                      ),
                    ],
                  ),
                )
              ],
            ));
      },
    );
  }
}
