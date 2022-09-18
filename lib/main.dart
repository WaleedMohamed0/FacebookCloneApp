import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/components/constants.dart';
import 'package:social_app/cubits/chats_cubit/chats_cubit.dart';
import 'package:social_app/cubits/posts_cubit/posts_cubit.dart';
import 'package:social_app/cubits/theme_manager/theme_cubit.dart';
import 'package:social_app/cubits/theme_manager/theme_states.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/network/cache_helper.dart';
import 'package:social_app/screens/login/login_screen.dart';
import 'package:social_app/screens/start_up/start_up_screen.dart';
import 'package:social_app/styles/theme_data.dart';
// @dart=2.9
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  loggedUserID = CacheHelper.getData(key: 'token');
  isDarkInCache = CacheHelper.getData(key: 'theme');
  runApp(MyApp(isDarkInCache));
}

class MyApp extends StatelessWidget {
  Widget? screen;
  bool isDarkInCache = false;

  MyApp(this.isDarkInCache, {super.key});

  @override
  Widget build(BuildContext context) {
    if (loggedUserID == null) {
      screen = LoginScreen();
    } else {
      screen = const StartUpScreen();
    }
    return ResponsiveSizer(
      builder: (p0, p1, p2) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => UserCubit()..getUsersData(),
            ),
            BlocProvider(
              create: (context) => PostsCubit(),
            ),
            BlocProvider(
              create: (context) => ChatsCubit(),
            ),
            BlocProvider(
              create: (context) => ThemeManagerCubit()
                ..changeTheme(isDarkInCache: isDarkInCache ?? false),
            ),
          ],
          child: BlocBuilder<ThemeManagerCubit, ThemeManagerStates>(
            builder: (context, state) {
              return MaterialApp(
                theme: lightMode,
                darkTheme: darkMode,
                themeMode: ThemeManagerCubit.get(context).isDark
                    ? ThemeMode.dark
                    : ThemeMode.light,
                debugShowCheckedModeBanner: false,
                home: (AnimatedSplashScreen(
                    splash: splash(),
                    centered: true,
                    splashIconSize: 900,
                    nextScreen: screen!)),
              );
            },
          ),
        );
      },
    );
  }

  Widget splash() {
    return Container(
      color: HexColor('242527'),
      width: double.infinity,
      child: Column(
        children: [
          const Spacer(),
          const Icon(
            Icons.facebook_rounded,
            size: 100,
            color: Colors.white,
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: Adaptive.h(2)),
            child: RichText(
              text: const TextSpan(text: "Developed by ",
                  style:TextStyle(
                    fontSize: 18
                  ),children: [
                TextSpan(
                    text: "Waleed Mohamed",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19
                    )),
              ]),
            ),
          ),
        ],
      ),
    );

    //Image.asset();
  }
}
