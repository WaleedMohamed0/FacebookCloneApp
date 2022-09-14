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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  loggedUserID = CacheHelper.getData(key: 'token');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget? screen;

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
              create: (context) => ThemeManagerCubit(),
            ),
          ],
          child: BlocConsumer<ThemeManagerCubit, ThemeManagerStates>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return MaterialApp(
                theme: lightMode,
                darkTheme: darkMode,
                themeMode: ThemeManagerCubit.get(context).isDark
                    ? ThemeMode.dark
                    : ThemeMode.light,
                debugShowCheckedModeBanner: false,
                home: screen,
              );
            },
          ),
        );
      },
    );
  }
}
