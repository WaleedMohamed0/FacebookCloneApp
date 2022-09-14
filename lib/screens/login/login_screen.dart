import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/components/constants.dart';
import 'package:social_app/cubits/posts_cubit/posts_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_states.dart';
import 'package:social_app/screens/start_up/start_up_screen.dart';

import '../../components/components.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var userCubit = UserCubit.get(context);
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          defaultToast(msg: "Login Successfully");
          navigateAndFinish(context, StartUpScreen());
        } else if (state is LoginErrorState) {
          defaultToast(
              msg: "Invalid Email or Password", backgroundColor: Colors.red);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: HexColor('3b5999'),
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  defaultText(
                      text: "facebook",
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      textColor: Colors.white),
                  SizedBox(
                    height: Adaptive.h(4),
                  ),
                  defaultTextField(
                    hintText: 'EmailAddress',
                    hintStyle: TextStyle(fontSize: 15),
                    controller: emailController,
                    style: TextStyle(
                      color: Colors.black,fontSize: 15
                    ),
                    prefixIcon: Icon(Icons.email_outlined),
                    textInput: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: Adaptive.h(4),
                  ),
                  defaultTextField(
                      hintText: 'Password',
                      isPass: userCubit.isPass,
                      hintStyle: TextStyle(fontSize: 15),
                      style: TextStyle(
                        color: Colors.black,fontSize: 15
                      ),
                      controller: passController,
                      prefixIcon: Icon(Icons.lock_outline),
                      textInput: TextInputType.visiblePassword,
                      suffix: userCubit.isPass
                          ? Icons.remove_red_eye
                          : Icons.visibility_off_outlined,
                      suffixPressed: () {
                        userCubit.changePasswordVisibility();
                      }),
                  SizedBox(
                    height: Adaptive.h(4),
                  ),
                  ConditionalBuilder(
                    condition: state is! LoginLoadingState,
                    builder: (context) => defaultBtn(
                      backgroundColor: HexColor('4f69a2'),
                      txt: 'Login',
                      isUpperCase: true,
                      function: () {
                        userCubit.userLogin(
                            email: emailController.text,
                            password: passController.text);
                      },
                      icon: Icons.login,
                    ),
                    fallback: (context) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Adaptive.h(4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      defaultText(
                          text: 'Don\'t have an account? ',
                          fontSize: 15,
                          textColor: Colors.white),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: RegisterScreen(),
                                  type: PageTransitionType.fade));
                        },
                        child: const Text(
                          'REGISTER',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
