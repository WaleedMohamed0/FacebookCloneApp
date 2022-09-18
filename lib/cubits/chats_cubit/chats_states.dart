abstract class ChatsStates {}

class ChatsInitialState extends ChatsStates {}
class GotChatImagePathLoadingState extends ChatsStates {}
class GotChatImagePathSuccessState extends ChatsStates {}
class RemoveChatImageSuccessState extends ChatsStates {}

class SendMessageLoadingState extends ChatsStates {}
class SendMessageSuccessState extends ChatsStates {}
class SendMessageErrorState extends ChatsStates {}

class GetMessagesSuccessState extends ChatsStates {}
class GetLastMessagesLoadingState extends ChatsStates {}
class GetLastMessagesSuccessState extends ChatsStates {}
class EmojiSelectState extends ChatsStates {}
