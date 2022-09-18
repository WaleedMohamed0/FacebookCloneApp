import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/components/components.dart';
import 'package:social_app/components/constants.dart';
import 'package:social_app/cubits/chats_cubit/chats_cubit.dart';
import 'package:social_app/cubits/chats_cubit/chats_states.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/cubits/user_cubit/user_states.dart';
import 'package:social_app/models/chat_model.dart';
import 'package:social_app/models/user_data.dart';
import 'package:social_app/screens/chats/chat_details.dart';

import '../../cubits/theme_manager/theme_cubit.dart';

class MessengerScreen extends StatelessWidget {
  const MessengerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userCubit = UserCubit.get(context);
    var chatsCubit = ChatsCubit.get(context);

    bool isDark = ThemeManagerCubit.get(context).isDark;

    return BlocBuilder<UserCubit, UserStates>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (UserCubit.get(context).userLogged != null &&
                    UserCubit.get(context).userLogged!.profilePhoto != "")
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage:
                        NetworkImage(userCubit.userLogged!.profilePhoto!),
                  ),
                SizedBox(
                  width: Adaptive.w(3),
                ),
                defaultText(
                    text: 'Chats',
                    myStyle: Theme.of(context).textTheme.headline1),
              ],
            ),
            actions: [
              CircleAvatar(
                backgroundColor:
                    isDark ? HexColor('303030') : HexColor('f5f5f5'),
                radius: 18,
                child: defaultIconButton(
                  icon: Icons.camera_alt,
                  size: 21.0,
                  color: Theme.of(context).iconTheme.color!,
                  onPressed: () {},
                ),
              ),
              SizedBox(
                width: Adaptive.w(3),
              ),
              Padding(
                padding: EdgeInsets.only(right: Adaptive.w(3.6)),
                child: CircleAvatar(
                  backgroundColor:
                      isDark ? HexColor('303030') : HexColor('f5f5f5'),
                  radius: 18,
                  child: defaultIconButton(
                    icon: Icons.edit,
                    size: 21.0,
                    color: Theme.of(context).iconTheme.color!,
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Adaptive.w(4), vertical: Adaptive.h(2.3)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Adaptive.w(2.3)),
                    child: Row(
                      children: [
                        Expanded(
                          child: searchTextField(
                              onChange: (String searchQuery) {
                                userCubit.searchMessengerUsers(
                                    searchQuery: searchQuery);
                              },
                              isDark: isDark,
                              context: context),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Adaptive.h(4),
                  ),
                  if (userCubit.users.isNotEmpty &&
                      state is! SearchMessengerUsersErrorState)
                    BlocBuilder<ChatsCubit, ChatsStates>(
                      builder: (context, state) {
                        return ConditionalBuilder(
                          condition: chatsCubit.lastMessages.length ==
                              userCubit.users.length,
                          builder: (context) {
                            return ListView.separated(
                              physics: BouncingScrollPhysics(),
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
                              separatorBuilder: (context, index) => SizedBox(
                                height: Adaptive.h(3),
                              ),
                              itemCount: userCubit.searchMessengerList.isEmpty
                                  ? userCubit.users.length
                                  : userCubit.searchMessengerList.length,
                            );
                          },
                          fallback: (context) => const Center(
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
                    myStyle: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(overflow: TextOverflow.ellipsis)),
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
                        myStyle: Theme.of(context).textTheme.subtitle2,
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
