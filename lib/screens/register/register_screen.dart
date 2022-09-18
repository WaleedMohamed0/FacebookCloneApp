import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_states.dart';

import '../../components/components.dart';
import '../login/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passController = TextEditingController();
    var phoneController = TextEditingController();
    var nameController = TextEditingController();
    var ageController = TextEditingController();
    var userCubit = UserCubit.get(context);
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {
        if (state is CreateUserSuccessState) {
          defaultToast(msg: "User Registered Successfully");
          // to deselect gender and pass
          userCubit.gender = "";
          if (!userCubit.isPass) {
            userCubit.changePasswordVisibility();
          }
          navigateAndFinish(context, LoginScreen());
        } else if (state is RegisterErrorState) {
          defaultToast(
              msg: "This Email is Already exists", backgroundColor: Colors.red);
        } else if (state is CreateUserErrorState) {
          defaultToast(msg: "Invalid Data", backgroundColor: Colors.red);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: HexColor('3b5999'),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: Adaptive.h(7),
                        left: Adaptive.w(7),
                        right: Adaptive.w(7)),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: defaultText(
                                text: "facebook",
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                                textColor: Colors.white),
                          ),
                          SizedBox(
                            height: Adaptive.h(4),
                          ),
                          defaultTextField(
                            hintText: 'Username',
                            controller: nameController,
                            prefixIcon: Icon(Icons.person),
                            textInput: TextInputType.name,
                            suffixIcon: Icons.clear,
                            valid: (String? value) {
                              if (value!.isEmpty) {
                                return 'Enter Your User Name';
                              }
                              return null;
                            },
                            suffixPressed: () {
                              nameController.clear();
                            },
                          ),
                          SizedBox(
                            height: Adaptive.h(3),
                          ),
                          defaultTextField(
                            hintText: 'Email Address',
                            controller: emailController,
                            prefixIcon: Icon(Icons.email_outlined),
                            textInput: TextInputType.emailAddress,
                            suffixIcon: Icons.clear,
                            valid: (String? value) {
                              bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@(gmail|hotmail|outlook)+\.com")
                                  .hasMatch(value!);

                              if (value.isEmpty) {
                                return 'Enter Your Email Address';
                              } else if (!emailValid) {
                                return 'Enter a Valid Email';
                              }
                              return null;
                            },
                            suffixPressed: () {
                              emailController.clear();
                            },
                          ),
                          SizedBox(
                            height: Adaptive.h(3),
                          ),
                          defaultTextField(
                            hintText: 'Phone',
                            controller: phoneController,
                            prefixIcon: Icon(Icons.phone),
                            textInput: TextInputType.phone,
                            suffixIcon: Icons.clear,
                            valid: (String? value) {
                              if (value!.isEmpty) {
                                return 'Enter Your Phone Number';
                              }
                              return null;
                            },
                            suffixPressed: () {
                              phoneController.clear();
                            },
                          ),
                          SizedBox(
                            height: Adaptive.h(3),
                          ),
                          defaultTextField(
                            hintText: 'Password',
                            isPass: userCubit.isPass,
                            controller: passController,
                            prefixIcon: Icon(Icons.lock_outline),
                            valid: (String? value) {
                              if (value!.isEmpty) {
                                return 'Enter Your Password';
                              } else if (value.length < 6) {
                                return 'Password at least 6 characters';
                              }
                              return null;
                            },
                            textInput: TextInputType.visiblePassword,
                            suffixIcon: userCubit.isPass
                                ? Icons.remove_red_eye
                                : Icons.visibility_off_outlined,
                            suffixPressed: () {
                              userCubit.changePasswordVisibility();
                            },
                          ),
                          SizedBox(
                            height: Adaptive.h(3),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                          value: "Male",
                                          groupValue: userCubit.gender,
                                          onChanged: (value) {
                                            userCubit
                                                .changeGender(value.toString());
                                          }),
                                      defaultText(
                                          text: 'Male', textColor: Colors.white)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                          value: "Female",
                                          groupValue: userCubit.gender,
                                          onChanged: (value) {
                                            userCubit
                                                .changeGender(value.toString());
                                          }),
                                      defaultText(
                                          text: 'Female',
                                          textColor: Colors.white)
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: Adaptive.w(36),
                                child: defaultTextField(
                                  hintText: 'Age',
                                  controller: ageController,
                                  textInput: TextInputType.phone,
                                  suffixIcon: Icons.clear,
                                  valid: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Your Age';
                                    }
                                    return null;
                                  },
                                  suffixPressed: () {
                                    ageController.clear();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Adaptive.h(2.5),
                          ),
                          Center(
                            child: ConditionalBuilder(
                              condition: state is! RegisterLoadingState,
                              builder: (context) => defaultBtn(
                                backgroundColor: HexColor('4f69a2'),
                                txt: 'Register',
                                isUpperCase: true,
                                function: () {
                                  if (formKey.currentState!.validate() &&
                                      userCubit.gender.isNotEmpty) {
                                    userCubit.userRegister(
                                        email: emailController.text,
                                        password: passController.text,
                                        phone: phoneController.text,
                                        name: nameController.text,
                                        age: ageController.text);
                                  } else if (userCubit.gender.isEmpty) {
                                    defaultToast(
                                        msg: 'Please Select Your Gender',
                                        backgroundColor: Colors.red);
                                  }
                                },
                                icon: Icons.app_registration,
                              ),
                              fallback: (context) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 5,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Adaptive.h(2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      defaultText(
                          text: 'Already have an account? ',
                          textColor: Colors.white),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: LoginScreen(),
                                  type: PageTransitionType.fade));
                        },
                        child: Text(
                          'LOGIN',
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
