import 'package:flutter/material.dart';
import 'package:flutter_chat_app/chats/chats.dart';
import 'package:flutter_chat_app/form/form.dart';
import 'package:flutter_chat_app/login/login.dart';
import 'package:flutter_chat_app/profile/profile.dart';
import 'package:flutter_chat_app/shared/bottom_nav.dart';
import 'package:flutter_chat_app/auth/sign_up.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.question_answer_rounded),
              label: 'Chat',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_box),
              label: 'New',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        body: Center(
          child: <Widget>[
            const ChatsScreen(),
            const SignUpScreen(),
            const ProfileScreen(),
          ][currentPageIndex],
        ));
  }
}
