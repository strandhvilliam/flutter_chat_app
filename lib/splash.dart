import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/supabase.dart' as supabase;
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _redirectCalled = false;

  void didChangeDependencies() {
    super.didChangeDependencies();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(seconds: 1));
    if (_redirectCalled || !mounted) return;

    _redirectCalled = true;
    final session = supabase.getSession();
    if (session == null) {
      context.go('/sign-up');
    } else {
      context.go('/chats');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
