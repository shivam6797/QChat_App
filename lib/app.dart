import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qchat_app/config/app_routes.dart';
import 'package:qchat_app/config/app_theme.dart';
import 'package:qchat_app/features/auth/bloc/auth_bloc.dart';
import 'package:qchat_app/features/auth/data/repository/auth_repository.dart';
import 'package:qchat_app/features/chat/bloc/chat_bloc.dart';
import 'package:qchat_app/features/chat/bloc/chat_event.dart';
import 'package:qchat_app/features/chat/data/repositories/chat_repository.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    final chatRepository = ChatRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(authRepository),
        ),
          BlocProvider(
          create: (_) => ChatBloc(chatRepository)..add(const FetchChats()),
           lazy: false, 
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRoutes.router,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
      ),
    );
  }
}
