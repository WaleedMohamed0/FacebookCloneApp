import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/components/constants.dart';
import 'package:social_app/cubits/posts_cubit/cubit.dart';
import 'package:social_app/cubits/user_cubit/cubit.dart';
import 'package:social_app/cubits/user_cubit/states.dart';
import 'package:social_app/screens/profile_screen/profile_screen.dart';

import '../../components/components.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = UserCubit.get(context);
    var userModel = UserCubit.get(context).userLogged;
    var nameController = TextEditingController(text: userModel!.name),
        passwordController = TextEditingController(text: userModel.password),
        phoneController = TextEditingController(text: userModel.phone),
        ageController = TextEditingController(text: userModel.age),
        educationController = TextEditingController(text: userModel.education),
        residenceController = TextEditingController(text: userModel.residence);
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {
        if (state is UpdateUserSuccessState) {
          defaultToast(msg: 'User Updated Successfully');
          PostsCubit.get(context).updatePostsData(userCubit: cubit);
          navigateAndFinish(context, const ProfileScreen());
        } else if (state is UpdateUserErrorState) {
          defaultToast(
            msg: "Error In Updating Profile",
            backgroundColor: Colors.red,
          );
        }
      },
      builder: (context, state) {
        List<Widget> profileTextFields = [
          defaultTextField(
              textInput: TextInputType.name,
              profileFields: true,
              controller: nameController),
          defaultTextField(
              textInput: TextInputType.visiblePassword,
              profileFields: true,
              controller: passwordController),
          defaultTextField(
              textInput: TextInputType.number,
              profileFields: true,
              controller: phoneController),
          defaultTextField(
              textInput: TextInputType.number,
              profileFields: true,
              controller: ageController),
          defaultTextField(
              textInput: TextInputType.text,
              profileFields: true,
              controller: educationController),
          defaultTextField(
              textInput: TextInputType.text,
              profileFields: true,
              controller: residenceController),
        ];

        return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Adaptive.w(2), vertical: Adaptive.h(1.5)),
                    height: Adaptive.h(43),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: Adaptive.h(30),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(
                                        10,
                                      ),
                                      topRight: Radius.circular(
                                        10,
                                      ),
                                    ),
                                    image: DecorationImage(
                                      image: cubit.coverImagePath == null
                                          ? NetworkImage(userModel.coverPhoto!)
                                          : FileImage(cubit.coverImagePath!)
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              CircleAvatar(
                                  child: defaultIconButton(
                                      icon: Icons.camera_alt_outlined,
                                      color: Colors.white,
                                      onPressed: () {
                                        cubit.changeCoverPhoto();
                                      }))
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                                radius: 88.0,
                                child: CircleAvatar(
                                    radius: 85.0,
                                    backgroundImage:
                                        cubit.profileImagePath == null
                                            ? NetworkImage(
                                                userModel.profilePhoto!,
                                              )
                                            : FileImage(cubit.profileImagePath!)
                                                as ImageProvider)),
                            CircleAvatar(
                                child: defaultIconButton(
                                    icon: Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    onPressed: () {
                                      cubit.changeProfilePhoto();
                                    }))
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (state is UploadProfileImageState ||
                      state is UploadCoverImageState ||
                      state is UpdateUserLoadingState)
                    SizedBox(
                      height: Adaptive.h(.5),
                    ),
                  if (state is UploadProfileImageState ||
                      state is UploadCoverImageState ||
                      state is UpdateUserLoadingState)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
                      child: const LinearProgressIndicator(),
                    ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: Adaptive.w(5.5)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              defaultText(
                                  text: profileTexts[index],
                                  fontWeight: FontWeight.bold),
                              SizedBox(
                                height: Adaptive.h(1),
                              ),
                              profileTextFields[index]
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                            height: Adaptive.h(1),
                          ),
                      itemCount: profileTexts.length),
                  SizedBox(
                    height: Adaptive.h(3),
                  ),
                  defaultBtn(
                      txt: 'Save',
                      function: () {
                        if (cubit.profileImagePath != null ||
                            cubit.coverImagePath != null) {
                          cubit.uploadUserImages(
                            name: nameController.text,
                            password: passwordController.text,
                            phone: phoneController.text,
                            age: ageController.text,
                            education: educationController.text,
                            residence: residenceController.text,
                          );
                        } else {
                          cubit.updateUser(
                            name: nameController.text,
                            password: passwordController.text,
                            phone: phoneController.text,
                            age: ageController.text,
                            education: educationController.text,
                            residence: residenceController.text,
                          );
                        }
                      },
                      borderRadius: 10),
                  SizedBox(
                    height: Adaptive.h(3),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
