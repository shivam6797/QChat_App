import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qchat_app/core/network/socket.client.dart';
import 'package:qchat_app/features/auth/data/repository/auth_repository.dart';
import 'package:qchat_app/features/chat/bloc/chat_bloc.dart';
import 'package:qchat_app/features/chat/bloc/chat_event.dart';
import 'package:qchat_app/features/chat/bloc/chat_state.dart';
import 'package:qchat_app/features/chat/data/model/chat_detail_model.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final String userName;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.userName,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  String? _userId;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasNewMessage = false;

  @override
  void initState() {
    super.initState();
    _loadUserId().then((_) {
      if (_userId != null) {
        SocketClient.connect("http://45.129.87.38:6065", _userId!);
        SocketClient.listenMessages(_onSocketMessage);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatBloc>().add(FetchChatMessages(widget.chatId));
    });
  }

  Future<void> _loadUserId() async {
    final userId = await AuthRepository().getUserId();
    setState(() {
      _userId = userId;
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_scrollController.hasClients) {
        await Future.delayed(const Duration(milliseconds: 50));
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onSocketMessage(dynamic data) {
    if (data['chatId'] == widget.chatId) {
      final msg = ChatDetailModel.fromJson(Map<String, dynamic>.from(data));
      final bloc = context.read<ChatBloc>();
      final currentState = bloc.state;

      if (currentState is ChatMessagesLoaded) {
        final updatedMessages = List<ChatDetailModel>.from(currentState.messages);
        updatedMessages.add(msg);
        bloc.emit(ChatMessagesLoaded(updatedMessages));
        _hasNewMessage = true;

        _scrollToBottom();
      } else {
        bloc.add(FetchChatMessages(widget.chatId));
      }
    }
  }

  String _formatTime(String? raw) {
    if (raw == null) return "";
    try {
      final dt = DateTime.parse(raw).toLocal();
      return DateFormat('hh:mm a').format(dt);
    } catch (_) {
      return "";
    }
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty || _userId == null) return;

    final messageEvent = SendMessageEvent(
      chatId: widget.chatId,
      senderId: _userId!,
      content: content,
      messageType: "text",
      fileUrl: "",
    );

    context.read<ChatBloc>().add(messageEvent);

    SocketClient.sendMessage({
      "chatId": widget.chatId,
      "senderId": _userId!,
      "content": content,
      "messageType": "text",
      "fileUrl": "",
    });

    _messageController.clear();
    _hasNewMessage = true;

    _scrollToBottom();
  }

  @override
  void dispose() {
    _messageController.dispose();
    SocketClient.disconnect();
    SocketClient.removeMessageListener(_onSocketMessage);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.userName, style: const TextStyle(color: Colors.white)),
        leadingWidth: 30,
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(_hasNewMessage);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatMessagesLoading) {
                  return const Center(child: CircularProgressIndicator(color: Colors.purple));
                } else if (state is ChatMessagesLoaded) {
                  final messages = state.messages;

                  if (messages.isEmpty) {
                    return const Center(
                      child: Text("No messages yet", style: TextStyle(color: Colors.white70)),
                    );
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    reverse: false,
                    itemBuilder: (context, index) {
                      final ChatDetailModel msg = messages[index];
                      final isMe = msg.senderId == _userId;

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.purple[600] : Colors.grey[800],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
                              bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(msg.content ?? "", style: TextStyle(color: isMe ? Colors.white : Colors.grey[200], fontSize: 15)),
                              const SizedBox(height: 4),
                              Text(_formatTime(msg.createdAt), style: TextStyle(color: isMe ? Colors.white70 : Colors.grey[500], fontSize: 11)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ChatMessagesError) {
                  return Center(child: Text("Error: ${state.message}", style: const TextStyle(color: Colors.redAccent)));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      filled: true,
                      fillColor: Colors.grey[850],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: CircleAvatar(backgroundColor: Colors.purple[600], child: const Icon(Icons.send, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
