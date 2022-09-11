import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/components/constants.dart';
import 'package:social_app/cubits/chats_cubit/chats_cubit.dart';
import 'package:social_app/cubits/chats_cubit/chats_states.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/models/user_data.dart';

import '../../components/components.dart';

class ChatDetails extends StatelessWidget {
  UserModel? model;

  ChatDetails({required this.model});

  @override
  Widget build(BuildContext context) {
    var messageController = TextEditingController();
    var chatCubit = ChatsCubit.get(context);
    ScrollController scrollController =
        ScrollController(initialScrollOffset: Adaptive.h(20000));

    return ConditionalBuilder(
      condition: model!.profilePhoto != "",
      builder: (context) {
        return Scaffold(
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
                  backgroundImage: NetworkImage(model!.profilePhoto!),
                ),
                SizedBox(
                  width: 15.0,
                ),
                defaultText(
                    text: model!.name!,
                    textColor: Colors.black,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ],
            ),
          ),
          body: Builder(
            builder: (context) {
              chatCubit.getMessages(receiverId: model!.uId!);
              return BlocConsumer<ChatsCubit, ChatsStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.only(
                        left: Adaptive.w(5.4),
                        right: Adaptive.w(5.4),
                        top: Adaptive.h(2.5),
                        bottom: Adaptive.h(.5)),
                    child: Column(
                      children: [
                        if (chatCubit.messages.isNotEmpty)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: Adaptive.h(2)),
                              child: ListView.separated(
                                  controller: scrollController,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    if (chatCubit.messages[index].senderId ==
                                        loggedUserID) {
                                      return buildSenderMessage(
                                          message:
                                              chatCubit.messages[index].text);
                                    }
                                    return buildReceiverMessage(
                                        message:
                                            chatCubit.messages[index].text);
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height: Adaptive.h(1),
                                      ),
                                  itemCount: chatCubit.messages.length),
                            ),
                          ),
                        if (chatCubit.messages.isEmpty) Spacer(),
                        Row(
                          children: [
                            Container(
                              width: Adaptive.w(82),
                              padding: EdgeInsets.zero,
                              child: defaultTextField(
                                  textInput: TextInputType.text,
                                  borderRadius: 30,
                                  fillColor: Colors.grey[100]!,
                                  hintText: "Message",
                                  controller: messageController,
                                  contentPadding: 22),
                            ),
                            SizedBox(
                              width: Adaptive.w(1),
                            ),
                            defaultIconButton(
                              icon: Icons.send_sharp,
                              onPressed: () {
                                // get to the end of screen when there's a new message
                                // maxScrollExtent to detect if screen is scrollable
                                if (scrollController.hasClients &&
                                    scrollController.position.maxScrollExtent >
                                        0) {
                                  scrollController.animateTo(
                                      scrollController
                                              .position.maxScrollExtent +
                                          Adaptive.h(8),
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.easeInOut);
                                }
                                chatCubit.sendMessage(
                                    text: messageController.text,
                                    receiverId: model!.uId!);
                                messageController.clear();
                              },
                              padding: EdgeInsets.zero,
                              size: 27,
                              constraints: BoxConstraints(),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      fallback: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildSenderMessage({required String message}) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: defaultText(text: message)),
    );
  }

  Widget buildReceiverMessage({required String message}) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: defaultText(text: message)),
    );
  }
}
