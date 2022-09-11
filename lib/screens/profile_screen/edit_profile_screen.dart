import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/components/constants.dart';
import 'package:social_app/cubits/posts_cubit/posts_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_states.dart';
import 'package:social_app/screens/profile_screen/profile_screen.dart';

import '../../components/components.dart';
import '../../models/user_data.dart';

class EditProfileScreen extends StatelessWidget {
  dynamic userModel;

  EditProfileScreen({this.userModel});

  @override
  Widget build(BuildContext context) {
    var cubit = UserCubit.get(context);
    var currentUser = UserCubit.get(context).userLogged;
    var nameController = TextEditingController(text: currentUser!.name),
        passwordController = TextEditingController(text: currentUser.password),
        phoneController = TextEditingController(text: currentUser.phone),
        ageController = TextEditingController(text: currentUser.age),
        educationController = TextEditingController(text: currentUser.education),
        residenceController = TextEditingController(text: currentUser.residence);
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {
        if (state is GetUsersDataSuccessState) {
          defaultToast(msg: 'User Updated Successfully');
          PostsCubit.get(context).updatePostsData(userCubit: cubit);
          Navigator.pop(context);
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
            backgroundColor: Colors.white,
            appBar:(userModel != null &&  userModel.uId == loggedUserID)
                ? defaultAppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    toolbarHeight: Adaptive.h(4))
                : null,
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
                                          ? NetworkImage(currentUser.coverPhoto!)
                                          : FileImage(cubit.coverImagePath!)
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                    child: defaultIconButton(
                                        icon: Icons.camera_alt_outlined,
                                        color: Colors.white,
                                        onPressed: () {
                                          cubit.changeCoverPhoto();
                                        })),
                              )
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
                                                currentUser.profilePhoto!,
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
                      physics: BouncingScrollPhysics(),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
                    child: Row(
                      children: [
                        Expanded(
                            child: defaultBtn(
                                txt: "Back",
                                function: () {
                                  Navigator.pop(context);
                                },
                                backgroundColor: Colors.transparent,
                                textColor: defaultColor)),
                        SizedBox(
                          width: Adaptive.w(3),
                        ),
                        Expanded(
                          child: defaultBtn(
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
                        ),
                      ],
                    ),
                  ),
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
