import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class FetchChats extends ChatEvent {
  const FetchChats();
}

class FetchChatMessages extends ChatEvent {
  final String chatId;

  const FetchChatMessages(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String senderId;
  final String content;
  final String messageType;
  final String fileUrl;

  const SendMessageEvent({
    required this.chatId,
    required this.senderId,
    required this.content,
    this.messageType = "text",
    this.fileUrl = "",
  });

  @override
  List<Object?> get props => [chatId, senderId, content, messageType, fileUrl];
}

