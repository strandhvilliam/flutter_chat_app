import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/models.dart';
import 'package:flutter_chat_app/services/supabase.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* class ProfileScreen extends StatelessWidget {
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
} */

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _authChecked = false;
  UserProfile _profileData = UserProfile();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getProfileData();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 1));
    if (_authChecked || !mounted) return;

    _authChecked = true;
    final session = SupabaseService.client.auth.currentSession;
    if (session == null) {
      context.go('/sign-in');
    }
  }

  _getProfileData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? profileData = prefs.getStringList('profile');
    if (profileData != null) {
      setState(() {
        _profileData = UserProfile(
          id: profileData[0],
          name: profileData[1],
          email: profileData[2],
          createdAt: DateTime.parse(profileData[3]),
          image: profileData[4],
        );
      });
    }
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
                backgroundImage: NetworkImage(_profileData.image),
              ),
              const SizedBox(height: 20),
              Text(
                _profileData.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => {},
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
                  SupabaseService.signOut(),
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
