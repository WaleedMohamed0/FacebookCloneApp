import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/components/components.dart';
import 'package:social_app/cubits/chats_cubit/cubit.dart';
import 'package:social_app/cubits/posts_cubit/cubit.dart';
import 'package:social_app/cubits/user_cubit/cubit.dart';
import 'package:social_app/cubits/user_cubit/states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_data.dart';
import 'package:social_app/screens/chats/chat_details.dart';

class MessengerScreen extends StatelessWidget {
  const MessengerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userCubit = UserCubit.get(context);

    return ConditionalBuilder(
      condition: userCubit.userLogged!.profilePhoto != "",
      builder: (context) {
        return BlocConsumer<UserCubit, UserStates>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return Scaffold(
              // resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0.0,
                // titleSpacing: 20.0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage:
                      NetworkImage(userCubit.userLogged!.profilePhoto!),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    defaultText(
                        text: 'Chats',
                        textColor: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ],
                ),
                actions: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    radius: 18,
                    child: defaultIconButton(
                      icon: Icons.camera_alt,
                      size: 21.0,
                      color: Colors.black,
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    width: Adaptive.w(3),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: Adaptive.w(3.6)),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      radius: 18,
                      child: defaultIconButton(
                        icon: Icons.edit,
                        size: 21.0,
                        color: Colors.black,
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Adaptive.w(4), vertical: Adaptive.h(1)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child:
                            searchTextField(onSubmit: (String searchQuery) {}),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      if (userCubit.users.isNotEmpty)
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) =>
                              buildChatItem(userCubit.users[index], context),
                          separatorBuilder: (context, index) =>
                              SizedBox(
                                height: 20.0,
                              ),
                          itemCount: userCubit.users.length,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      fallback: (context) =>
          Center(
            child: CircularProgressIndicator(),
          ),
    );
  }

  Widget buildChatItem(UserModel model, context) =>
      InkWell(
        onTap: () {
          navigateToWithAnimation(
              context: context,
              nextScreen: ChatDetails(model: model),
              pageTransitionType: PageTransitionType.rightToLeft);
        },
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(model.profilePhoto!),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    bottom: 3.0,
                    end: 3.0,
                  ),
                  child: CircleAvatar(
                    radius: 7.0,
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  defaultText(
                    text: model.name!,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    linesMax: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'hello my name is abdullah ahmed hello my name is abdullah ahmed',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        child: Container(
                          width: 7.0,
                          height: 7.0,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Text(
                        '02:00 pm',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

// Widget buildStoryItem() => Container(
//       width: 60.0,
//       child: Column(
//         children: [
//           Stack(
//             alignment: AlignmentDirectional.bottomEnd,
//             children: [
//               CircleAvatar(
//                 radius: 30.0,
//                 backgroundImage: NetworkImage(
//                     'https://avatars.githubusercontent.com/u/34492145?v=4'),
//               ),
//               Padding(
//                 padding: const EdgeInsetsDirectional.only(
//                   bottom: 3.0,
//                   end: 3.0,
//                 ),
//                 child: CircleAvatar(
//                   radius: 7.0,
//                   backgroundColor: Colors.red,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 6.0,
//           ),
//           Text(
//             'Abdullah Mansour Ali Mansour',
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
}
