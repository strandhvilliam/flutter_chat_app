import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/models.dart';
import 'package:flutter_chat_app/services/supabase.dart' as supabase;
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _authChecked = false;
  UserProfile? _profileData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getProfileData();
  }

  _getProfileData() async {
    final String userId = supabase.getCurrentUser()!.id;
    final UserProfile profile = await supabase.getProfile(userId);
    setState(() {
      _profileData = profile;
    });
  }

  @override
  void initState() {
    super.initState();
    _getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 100),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_profileData?.image ??
                    'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541'),
              ),
              const SizedBox(height: 20),
              Text(
                _profileData?.name ?? '...',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {},
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size(200, 50),
                  ),
                ),
                child: const Text('View friends'),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () => {
                  supabase.signOut(),
                  context.go('/sign-in'),
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size(200, 50),
                  ),
                ),
                child: const Text('Sign out'),
              ),
            ],
          ),
        ));
  }
}
