import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/supabase.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              onPressed: () {
                SupabaseService.signOut();
              },
              child: const Text('Sign out'),
            ),
            TextButton(
              onPressed: () {
                SupabaseService.signIn('test@test.com', '123456');
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
