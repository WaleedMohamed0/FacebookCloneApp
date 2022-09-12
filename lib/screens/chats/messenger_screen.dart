import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/components/components.dart';
import 'package:social_app/components/constants.dart';
import 'package:social_app/cubits/chats_cubit/chats_cubit.dart';
import 'package:social_app/cubits/chats_cubit/chats_states.dart';
import 'package:social_app/cubits/posts_cubit/posts_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_states.dart';
import 'package:social_app/models/chat_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_data.dart';
import 'package:social_app/screens/chats/chat_details.dart';

class MessengerScreen extends StatelessWidget {
  const MessengerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userCubit = UserCubit.get(context);
    var chatsCubit = ChatsCubit.get(context);

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
                    if(UserCubit.get(context).userLogged != null &&
                        UserCubit.get(context).userLogged!.profilePhoto !=
                            "")
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
                                searchTextField(onChange: (String searchQuery) {
                              userCubit.searchMessengerUsers(
                                  searchQuery: searchQuery);
                            }),
                          )
                        ],
                      ),
                      SizedBox(
                        height: Adaptive.h(2),
                      ),
                      if (userCubit.users.isNotEmpty &&
                          state is! SearchMessengerUsersErrorState)
                        BlocConsumer<ChatsCubit, ChatsStates>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            return ConditionalBuilder(
                              condition: chatsCubit.lastMessages.length ==
                                  userCubit.users.length,
                              builder: (context) {
                                return ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return buildChatItem(
                                        userCubit.searchMessengerList.isEmpty
                                            ? userCubit.users[index]
                                            : userCubit
                                                .searchMessengerList[index],
                                        context,
                                        chatsCubit.lastMessages[index]);
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: Adaptive.h(2),
                                  ),
                                  itemCount: userCubit
                                          .searchMessengerList.isEmpty
                                      ? userCubit.users.length
                                      : userCubit.searchMessengerList.length,
                                );
                              },
                              fallback: (context) => Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      fallback: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildChatItem(UserModel model, context, ChatModel? lastMessage) {
    return InkWell(
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
                padding: EdgeInsetsDirectional.only(
                  bottom: Adaptive.h(.3),
                  end: Adaptive.h(.3),
                ),
                child: CircleAvatar(
                  radius: 7.0,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(
            width: Adaptive.w(4),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                defaultText(
                  text: model.name!,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: Adaptive.h(2),
                ),
                Row(
                  children: [
                    Expanded(
                      child: defaultText(
                          text: lastMessage!.senderId == loggedUserID
                              ? "You: " '${lastMessage.text}'
                              : lastMessage.text,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                          fontWeight: lastMessage.senderId == loggedUserID
                              ? FontWeight.normal
                              : FontWeight.bold),
                    ),
                    defaultText(
                        text: lastMessage.dateTime,
                        fontWeight: lastMessage.senderId == loggedUserID
                            ? FontWeight.normal
                            : FontWeight.bold),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
