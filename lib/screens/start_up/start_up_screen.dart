import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/cubits/chats_cubit/chats_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_states.dart';
import 'package:social_app/screens/chats/messenger_screen.dart';

import '../../components/components.dart';
import '../../components/constants.dart';
import '../posts_screen/home_screen.dart';
import '../notification_screen/notification_screen.dart';
import '../profile_screen/profile_screen.dart';

class StartUpScreen extends StatelessWidget {
  const StartUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
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
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 27,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: InkWell(
                      hoverColor: transparentColor,
                      splashColor: transparentColor,
                      focusColor: transparentColor,
                      highlightColor: transparentColor,
                      onTap: () {
                        ChatsCubit.get(context).getLastMessages(context);
                        navigateToWithAnimation(
                            context: context,
                            nextScreen: MessengerScreen(),
                            durationInMilliSecs: 500,
                            pageTransitionType: PageTransitionType.rightToLeft);
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: 20,
                          child: Image.asset(
                            'assets/images/messanger.png',
                            width: 27,
                          )),
                    ),
                  ),
                ],
                backgroundColor: Colors.white,
                bottom: TabBar(
                    indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(width: 3.0),
                        insets:
                            EdgeInsets.symmetric(horizontal: Adaptive.w(9))),
                    unselectedLabelColor: Colors.grey[600],
                    labelColor: Colors.blue,
                    tabs: [
                      SizedBox(
                        width: Adaptive.w(20),
                        child: Tab(
                            icon: Icon(
                          Icons.home,
                          size: 28,
                        )),
                      ),
                      SizedBox(
                          width: Adaptive.w(20),
                          child: Tab(
                              icon: Icon(
                            Icons.person,
                            size: 28,
                          ))),
                      SizedBox(
                          width: Adaptive.w(20),
                          child: Tab(
                              icon: Icon(
                            Icons.notifications,
                            size: 28,
                          ))),
                    ]),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  MaterialApp(
                    home: HomeScreen(),
                    debugShowCheckedModeBanner: false,
                  ),
                  MaterialApp(
                    home: ProfileScreen(),
                    debugShowCheckedModeBanner: false,
                  ),
                  MaterialApp(
                    home: NotificationsScreen(),
                    debugShowCheckedModeBanner: false,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
