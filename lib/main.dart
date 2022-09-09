import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/cubits/chats_cubit/cubit.dart';
import 'package:social_app/cubits/posts_cubit/cubit.dart';
import 'package:social_app/cubits/user_cubit/cubit.dart';
import 'package:social_app/screens/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (p0, p1, p2) {
        return  MultiBlocProvider(
          providers:
          [
            BlocProvider(create: (context) => UserCubit(),),
            BlocProvider(create: (context) => PostsCubit()..getAllPosts(),),
            BlocProvider(create: (context) => ChatsCubit(),),

          ],
          child: MaterialApp(
            theme: ThemeData(
              scaffoldBackgroundColor: HexColor("3b5999"),

            ),
            debugShowCheckedModeBanner: false,
            home: LoginScreen(),
          ),
        );
      },
    );
  }
}
