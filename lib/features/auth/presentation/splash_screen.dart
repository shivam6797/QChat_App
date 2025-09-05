import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qchat_app/config/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (mounted) {
      if (token != null && token.isNotEmpty) {
        context.goNamed(AppRoutes.chatList);
      } else {
        context.goNamed(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A148C),
              Color(0xFF000000),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purpleAccent, Colors.deepPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(60),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "Q",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "QChat",
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Connect Smarter, Chat Faster",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
              strokeWidth: 4,
            ),
          ],
        ),
      ),
    );
  }
}
