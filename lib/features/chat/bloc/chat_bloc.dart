import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qchat_app/features/chat/bloc/chat_event.dart';
import 'package:qchat_app/features/chat/bloc/chat_state.dart';
import 'package:qchat_app/features/chat/data/model/chat_detail_model.dart';
import 'package:qchat_app/features/chat/data/model/chat_model.dart';
import 'package:qchat_app/features/chat/data/repositories/chat_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  List<ChatModel> _cachedChats = [];

  ChatBloc(this._chatRepository) : super(const ChatInitial()) {
    on<FetchChats>(_onFetchChats);
    on<FetchChatMessages>(_onFetchChatMessages);
    on<SendMessageEvent>(_onSendMessage);
  }

  @override
  void onChange(Change<ChatState> change) {
    super.onChange(change);
    if (change.nextState is ChatLoaded) {
      _cachedChats = (change.nextState as ChatLoaded).chats;
    }
  }

  Future<void> _onFetchChats(FetchChats event, Emitter<ChatState> emit) async {
    if (_cachedChats.isNotEmpty) {
      emit(ChatLoaded(_cachedChats));
    }
    
    emit(ChatLoading());
    try {
      final chats = await _chatRepository.fetchChats();
      _cachedChats = chats;
      emit(ChatLoaded(chats));
    } catch (e) {
      if (_cachedChats.isNotEmpty) {
        emit(ChatLoaded(_cachedChats));
      } else {
        emit(ChatError(e.toString()));
      }
    }
  }

  Future<void> _onFetchChatMessages(FetchChatMessages event, Emitter<ChatState> emit) async {
    emit(ChatMessagesLoading());
    try {
      final messages = await _chatRepository.getMessages(event.chatId);
      emit(ChatMessagesLoaded(messages));
    } catch (e) {
      emit(ChatMessagesError(e.toString()));
    }
  }

  Future<void> _onSendMessage(
  SendMessageEvent event,
  Emitter<ChatState> emit,
) async {
  try {
    final newMessage = await _chatRepository.sendMessage(
      chatId: event.chatId,
      senderId: event.senderId,
      content: event.content,
      messageType: event.messageType,
      fileUrl: event.fileUrl,
    );

    if (state is ChatMessagesLoaded) {
      final currentMessages = List<ChatDetailModel>.from(
          (state as ChatMessagesLoaded).messages);

      currentMessages.add(newMessage);
      emit(ChatMessagesLoaded(currentMessages));
    } else {
      final messages = await _chatRepository.getMessages(event.chatId);
      emit(ChatMessagesLoaded(messages));
    }
  } catch (e) {
    emit(ChatMessagesError(e.toString()));
  }
}

}