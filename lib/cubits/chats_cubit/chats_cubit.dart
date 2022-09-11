import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/components/constants.dart';
import 'package:social_app/cubits/chats_cubit/chats_states.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/models/chat_model.dart';

class ChatsCubit extends Cubit<ChatsStates> {
  ChatsCubit() : super(ChatsInitialState());

  static ChatsCubit get(context) => BlocProvider.of(context);

  ChatModel? chatModel;

  void sendMessage({required String text, required String receiverId}) {
    emit(SendMessageLoadingState());
    chatModel = ChatModel(
      receiverId: receiverId,
      senderId: loggedUserID,
      text: text,
      dateTime:
          DateFormat('yyyy-MM-dd – h:mm:ss a').format(DateTime.now()).toString(),
    );

    // send message to my chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(loggedUserID)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(chatModel!.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });

    // send message to receivers' chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(loggedUserID)
        .collection('messages')
        .add(chatModel!.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
  }

  List<ChatModel> messages = [];

  void getMessages({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(loggedUserID)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime', descending: false)
        .snapshots()
        .listen((event) {
      messages.clear();
      for (var element in event.docs) {
        messages.add(ChatModel(
            receiverId: receiverId,
            senderId: element.data()['senderId'],
            text: element.data()['text'],
            dateTime: element.data()['dateTime']));
      }

      emit(GetMessagesSuccessState());
    });
  }
}
