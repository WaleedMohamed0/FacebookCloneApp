import 'package:conditional_builder/conditional_builder.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_app/components/constants.dart';
import 'package:social_app/cubits/chats_cubit/chats_cubit.dart';
import 'package:social_app/cubits/chats_cubit/chats_states.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/models/chat_model.dart';
import 'package:social_app/models/user_data.dart';

import '../../components/components.dart';

class ChatDetails extends StatelessWidget {
  UserModel? model;

  ChatDetails({required this.model});

  @override
  Widget build(BuildContext context) {
    var messageController = TextEditingController();
    var chatsCubit = ChatsCubit.get(context);
    ScrollController scrollController =
        ScrollController(initialScrollOffset: Adaptive.h(20000));

    return ConditionalBuilder(
      condition: model!.profilePhoto != "",
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            if (chatsCubit.emojiShow) {
              // when user clicks on back button in his mobile
              chatsCubit.getLastMessages(context);
              Navigator.pop(context);
            } else {
              chatsCubit.emojiSelect();
            }
            return false;
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(model!.profilePhoto!),
                  ),
                  SizedBox(
                    width: Adaptive.w(3.5),
                  ),
                  SizedBox(
                    width: Adaptive.w(63.5),
                    child: defaultText(
                        text: model!.name!,
                        myStyle: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(overflow: TextOverflow.ellipsis,fontSize: 20)),
                  ),
                ],
              ),
            ),
            body: Builder(
              builder: (context) {
                chatsCubit.getMessages(receiverId: model!.uId!);
                return BlocConsumer<ChatsCubit, ChatsStates>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: Adaptive.w(5.4),
                          right: Adaptive.w(5.4),
                          top: Adaptive.h(2.5),
                          bottom: Adaptive.h(.6)),
                      child: Column(
                        children: [
                          if (chatsCubit.messages.isNotEmpty)
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: Adaptive.h(2)),
                                child: ListView.separated(
                                    controller: scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      if (chatsCubit.messages[index].senderId ==
                                          loggedUserID) {
                                        return buildSenderMessage(
                                            message: chatsCubit.messages[index],
                                            context: context);
                                      }
                                      return buildReceiverMessage(
                                          message: chatsCubit.messages[index],
                                          context: context);
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                          height: Adaptive.h(1),
                                        ),
                                    itemCount: chatsCubit.messages.length),
                              ),
                            ),

                          if (chatsCubit.messages.isEmpty) const Spacer(),
                          Row(
                            children: [
                              Container(
                                width: Adaptive.w(80),
                                padding: EdgeInsets.zero,
                                child: defaultTextField(
                                    textInput: TextInputType.text,
                                    borderRadius: 33,
                                    borderColor: Colors.grey[100]!,
                                    fillColor: Colors.grey[100]!,
                                    hintText: "Message",
                                    onTap: () {
                                      // close emojis if keyboard is on
                                      if (!chatsCubit.emojiShow) {
                                        chatsCubit.emojiSelect();
                                      }
                                    },
                                    prefixIcon: InkWell(
                                        onTap: () {
                                          // open emojis and close keyboard
                                          FocusScopeNode currentFocus =
                                              FocusScope.of(context);
                                          if (!currentFocus.hasPrimaryFocus) {
                                            currentFocus.unfocus();
                                          }
                                          chatsCubit.emojiSelect();
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: Adaptive.w(2.2)),
                                          child: const Icon(
                                              Icons.emoji_emotions_outlined),
                                        )),
                                    controller: messageController,
                                    contentPadding: 17),
                              ),
                              SizedBox(
                                width: Adaptive.w(3),
                              ),
                              defaultIconButton(
                                icon: Icons.send_sharp,
                                onPressed: () {
                                  if (messageController.text != "") {
                                    // get to the end of screen when there's a new message
                                    // maxScrollExtent to detect if screen is scrollable
                                    if (scrollController.hasClients &&
                                        scrollController
                                                .position.maxScrollExtent >
                                            0) {
                                      scrollController.animateTo(
                                          scrollController
                                                  .position.maxScrollExtent +
                                              Adaptive.h(8),
                                          duration: Duration(milliseconds: 400),
                                          curve: Curves.easeInOut);
                                    }
                                    chatsCubit.sendMessage(
                                        text: messageController.text,
                                        receiverId: model!.uId!);
                                    messageController.clear();
                                  }
                                },
                                padding: EdgeInsets.zero,
                                size: 27,
                                constraints: BoxConstraints(),
                              ),
                            ],
                          ),
                          // Emojis Tab
                          Offstage(
                            offstage: chatsCubit.emojiShow,
                            child: SizedBox(
                              height: Adaptive.h(30),
                              child: EmojiPicker(
                                textEditingController: messageController,
                                onEmojiSelected:
                                    (Category category, Emoji emoji) {},
                                config: const Config(
                                  columns: 7,
                                  emojiSizeMax: 32,
                                  verticalSpacing: 0,
                                  horizontalSpacing: 0,
                                  gridPadding: EdgeInsets.zero,
                                  initCategory: Category.RECENT,
                                  bgColor: Color(0xFFF2F2F2),
                                  indicatorColor: defaultColor,
                                  iconColor: Colors.grey,
                                  iconColorSelected: defaultColor,
                                  progressIndicatorColor: defaultColor,
                                  backspaceColor: defaultColor,
                                  skinToneDialogBgColor: Colors.white,
                                  skinToneIndicatorColor: Colors.grey,
                                  enableSkinTones: true,
                                  showRecentsTab: true,
                                  recentsLimit: 28,
                                  replaceEmojiOnLimitExceed: false,
                                  noRecents: Text(
                                    'No Recents',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black26),
                                    textAlign: TextAlign.center,
                                  ),
                                  tabIndicatorAnimDuration: kTabScrollDuration,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
      fallback: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildSenderMessage({required ChatModel message, context}) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Adaptive.w(2.5), vertical: Adaptive.h(1)),
          decoration: BoxDecoration(
            color: defaultColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              defaultText(
                text: message.text,
                textColor: Colors.white,
              ),
              SizedBox(
                height: Adaptive.h(.8),
              ),
              defaultText(
                  text:
                     message.dateTime,
                  myStyle: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontSize: 10, color: Colors.grey[400]),
                  textAlign: TextAlign.end)
            ],
          )),
    );
  }

  Widget buildReceiverMessage({required ChatModel message, context}) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Adaptive.w(2.5), vertical: Adaptive.h(1)),
          decoration: BoxDecoration(
            color: HexColor('f1f1f1'),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              defaultText(text: message.text, textColor: Colors.black),
              SizedBox(
                height: Adaptive.h(.8),
              ),
              defaultText(
                  // to take only time without date

                  text: message.dateTime,
                  myStyle: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontSize: 10, color: Colors.grey[500]),
                  textAlign: TextAlign.end)
            ],
          )),
    );
  }
}
