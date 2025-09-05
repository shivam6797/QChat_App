import 'package:equatable/equatable.dart';
import 'package:qchat_app/features/chat/data/model/chat_model.dart';
import 'package:qchat_app/features/chat/data/model/chat_detail_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatLoaded extends ChatState {
  final List<ChatModel> chats;
  const ChatLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatMessagesLoading extends ChatState {
  const ChatMessagesLoading();
}

class ChatMessagesLoaded extends ChatState {
  final List<ChatDetailModel> messages;
  const ChatMessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatMessagesError extends ChatState {
  final String message;
  const ChatMessagesError(this.message);

  @override
  List<Object?> get props => [message];
}
