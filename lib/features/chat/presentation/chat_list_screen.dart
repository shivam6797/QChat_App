import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qchat_app/features/auth/data/repository/auth_repository.dart';
import 'package:qchat_app/features/chat/bloc/chat_bloc.dart';
import 'package:qchat_app/features/chat/bloc/chat_event.dart';
import 'package:qchat_app/features/chat/bloc/chat_state.dart';
import 'package:qchat_app/features/chat/presentation/chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> with AutomaticKeepAliveClientMixin {
  String? _userId;
  bool _isInitialLoad = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final userId = await AuthRepository().getUserId();
    setState(() {
      _userId = userId;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialLoad) {
      context.read<ChatBloc>().add(const FetchChats());
      _isInitialLoad = false;
    }
  }

  String _formatLastSeen(String? raw) {
    if (raw == null) return "";
    try {
      final dateTime = DateTime.parse(raw).toLocal();
      final now = DateTime.now();

      if (now.difference(dateTime).inDays == 0) {
        return DateFormat('hh:mm a').format(dateTime);
      } else if (now.difference(dateTime).inDays == 1) {
        return "Yesterday";
      } else {
        return DateFormat('d MMM').format(dateTime);
      }
    } catch (_) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.black87,
        title: const Text("Qchats", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await AuthRepository().logout();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context, 
                  '/login', 
                  (route) => false
                );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        buildWhen: (previous, current) {
          return current is ChatLoaded || 
                 current is ChatLoading || 
                 current is ChatError;
        },
        builder: (context, state) {
          if (state is ChatLoading && _isInitialLoad) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.purple),
            );
          } else if (state is ChatLoaded) {
            final chats = state.chats;
            if (chats.isEmpty) {
              return const Center(
                child: Text(
                  "No chats available", 
                  style: TextStyle(color: Colors.white)
                ),
              );
            }

            return RefreshIndicator(
              color: Colors.purple,
              onRefresh: () async {
                context.read<ChatBloc>().add(const FetchChats());
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.separated(
                itemCount: chats.length,
                separatorBuilder: (_, __) => const Divider(height: 0.1, color: Colors.grey),
                itemBuilder: (context, index) {
                  final chat = chats[index];

                  final other = chat.participants!.firstWhere(
                    (p) => p.id != _userId,
                    orElse: () => chat.participants!.first,
                  );

                  final firstLetter = (other.name != null && other.name!.isNotEmpty)
                      ? other.name![0].toUpperCase()
                      : "?";

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.purple[400],
                      child: Text(
                        firstLetter,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            other.name ?? "Unknown",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          other.isOnline == true
                              ? "Online"
                              : _formatLastSeen(other.lastSeen),
                          style: TextStyle(
                            fontSize: 12,
                            color: other.isOnline == true
                                ? Colors.green
                                : Colors.grey[600],
                            fontWeight: other.isOnline == true
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      chat.lastMessage?.content ?? "No messages yet",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                    onTap: () async {
                      final shouldRefresh = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatDetailScreen(
                            chatId: chat.id!,
                            userName: other.name ?? "Chat",
                          ),
                        ),
                      );
                      
                      if (shouldRefresh == true && mounted) {
                        context.read<ChatBloc>().add(const FetchChats());
                      }
                    },
                  );
                },
              ),
            );
          } else if (state is ChatError) {
            return Center(
              child: Text(
                "Error: ${state.message}", 
                style: const TextStyle(color: Colors.white)
              ),
            );
          }
          
final bloc = context.read<ChatBloc>();
if (bloc.state is ChatLoaded) {
  final loadedState = bloc.state as ChatLoaded;
  final chats = loadedState.chats;
  
  if (chats.isEmpty) {
    return const Center(
      child: Text(
        "No chats available", 
        style: TextStyle(color: Colors.white)
      ),
    );
  }

  return RefreshIndicator(
    color: Colors.purple,
    onRefresh: () async {
      context.read<ChatBloc>().add(const FetchChats());
      await Future.delayed(const Duration(seconds: 1));
    },
    child: ListView.separated(
      itemCount: chats.length,
      separatorBuilder: (_, __) => const Divider(height: 0.1, color: Colors.grey),
      itemBuilder: (context, index) {
        final chat = chats[index];

        final other = chat.participants!.firstWhere(
          (p) => p.id != _userId,
          orElse: () => chat.participants!.first,
        );

        final firstLetter = (other.name != null && other.name!.isNotEmpty)
            ? other.name![0].toUpperCase()
            : "?";

        return ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: Colors.purple[400],
            child: Text(
              firstLetter,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  other.name ?? "Unknown",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                other.isOnline == true
                    ? "Online"
                    : _formatLastSeen(other.lastSeen),
                style: TextStyle(
                  fontSize: 12,
                  color: other.isOnline == true
                      ? Colors.green
                      : Colors.grey[600],
                  fontWeight: other.isOnline == true
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
          subtitle: Text(
            chat.lastMessage?.content ?? "No messages yet",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
          onTap: () async {
            final shouldRefresh = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatDetailScreen(
                  chatId: chat.id!,
                  userName: other.name ?? "Chat",
                ),
              ),
            );
            
            if (shouldRefresh == true && mounted) {
              context.read<ChatBloc>().add(const FetchChats());
            }
          },
        );
      },
    ),
  );
}
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
}