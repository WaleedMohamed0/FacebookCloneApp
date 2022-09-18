import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_app/components/constants.dart';
import 'package:social_app/cubits/chats_cubit/chats_states.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/models/chat_model.dart';

class ChatsCubit extends Cubit<ChatsStates> {
  ChatsCubit() : super(ChatsInitialState());

  static ChatsCubit get(context) => BlocProvider.of(context);

  final ImagePicker chatImagePicker = ImagePicker();
  File? chatImagePath;

  void getPostImage() {
    emit(GotChatImagePathLoadingState());
    chatImagePicker
        .pickImage(
      source: ImageSource.gallery,
    )
        .then((value) {
      chatImagePath = File(value!.path);
      emit(GotChatImagePathSuccessState());
    });
  }

  void uploadChatImage({required String text, required String receiverId}) {
    FirebaseStorage.instance
        .ref()
        .child('chats/${Uri.file(chatImagePath!.path).pathSegments.last}')
        .putFile(chatImagePath!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        sendMessage(
            text: text, chatImage: value.toString(), receiverId: receiverId);
      }).then((value) {
        removeChatImage();
      }).catchError((error) {});
    }).catchError((error) {});
  }

  void removeChatImage() {
    chatImagePath = null;
    emit(RemoveChatImageSuccessState());
  }

  ChatModel? chatModel;

  void sendMessage(
      {required String text, required String receiverId, String? chatImage}) {
    emit(SendMessageLoadingState());
    chatModel = ChatModel(
      receiverId: receiverId,
      senderId: loggedUserID!,
      text: text,
      chatImage: chatImage ?? "",
      dateTime: DateFormat('yyyy-MM-dd – h:mm:ss a')
          .format(DateTime.now())
          .toString(),
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
          senderId: element['senderId'],
          text: element['text'],
          chatImage: element['chatImage'],
          // to get time without date
          dateTime: element['dateTime']
                  .substring(13, element['dateTime'][14] == ":" ? 17 : 18) +
              " " +
              element['dateTime']
                  .substring(element['dateTime'][21] == " " ? 22 : 21),
        ));
      }

      emit(GetMessagesSuccessState());
    });
  }

  List<ChatModel> lastMessages = [];
  bool gotLastMessages = false;

  void getLastMessages(context) async {
    emit(GetLastMessagesLoadingState());
    lastMessages.clear();
    UserCubit.get(context).searchMessengerList.clear();
    for (var user in UserCubit.get(context).users) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedUserID)
          .collection('chats')
          .doc(user.uId)
          .collection('messages')
          .orderBy('dateTime', descending: false)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          lastMessages.add(ChatModel(
              receiverId: value.docs.last['receiverId'],
              senderId: value.docs.last['senderId'],
              text: value.docs.last['text'],
              dateTime:
                  "${value.docs.last['dateTime'].toString().substring(12, value.docs.last['dateTime'][14] == ":" ? 17 : 18)}"
                  " ${value.docs.last['dateTime'].toString().substring(21)}"));
        }
        // to fill list length with users length to avoid errors
        else {
          lastMessages.add(
              ChatModel(receiverId: '', senderId: '', text: '', dateTime: ''));
        }
      }).then((value) {
        emit(GetLastMessagesSuccessState());
      });
    }
  }

  bool emojiShow = true;

  void emojiSelect() {
    emojiShow = !emojiShow;
    emit(EmojiSelectState());
  }
}
