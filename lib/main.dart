import 'package:flutter/material.dart';
import 'package:flutter_chat_app/auth/sign_in.dart';
import 'package:flutter_chat_app/home/home.dart';
import 'package:flutter_chat_app/profile/profile.dart';
import 'package:flutter_chat_app/routes.dart';
import 'package:flutter_chat_app/services/supabase.dart';
import 'package:flutter_chat_app/auth/sign_up.dart';
import 'package:flutter_chat_app/splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  print(dotenv.env['SUPABASE_URL']!);
  print(dotenv.env['SUPABASE_ANON_KEY']!);

  await Supabase.initialize(
      url: "https://ikdmcrvpseyziskpusit.supabase.co",
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlrZG1jcnZwc2V5emlza3B1c2l0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODExNTUwNzksImV4cCI6MTk5NjczMTA3OX0.6GjpSgAxGUMOehKXgmokANWwMbkkG_omSR_YithRe_o');

  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInScreen(),
    )
    /* GoRoute(
      path: '/chat/:id',
      pageBuilder: (context, state) => ChatScreen(
        roomId: state.params['id'],
      ),
    ), */
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Chat App',
    );
  }
}
