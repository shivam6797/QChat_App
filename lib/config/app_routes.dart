import 'package:go_router/go_router.dart';
import 'package:qchat_app/features/auth/presentation/login_screen.dart';
import 'package:qchat_app/features/auth/presentation/splash_screen.dart';
import 'package:qchat_app/features/chat/presentation/chat_detail_screen.dart';
import 'package:qchat_app/features/chat/presentation/chat_list_screen.dart';

class AppRoutes {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String chatList = 'chatList';
  static const String chatDetail = 'chatDetail';

  static GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/chatList',
        name: chatList,
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        path: '/chatDetail/:chatId',
        name: chatDetail,
        builder: (context, state) {
          final chatId = state.pathParameters['chatId']!;
          final userName = state.extra as String? ?? "Chat";
          return ChatDetailScreen(chatId: chatId, userName: userName);
        },
      ),
    ],
  );
}