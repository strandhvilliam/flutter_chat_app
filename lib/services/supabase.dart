import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.blue,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}

class SupabaseService {
  static final client = Supabase.instance.client;

  static Future<List<ChatRoom>> fetchRooms() async {
    final roomsRes = await client.from('chat_room').select() as List;

    final membersRes = await client.from('members').select() as List;

    final usersRes = await client.from('user_profile').select() as List;

    final users = usersRes.map((e) {
      return UserProfile(
        id: e['id'].toString(),
        name: e['name'],
        createdAt: e['created_at'],
      );
    }).toList();

    final rooms = roomsRes.map((e) {
      return ChatRoom(
        id: e['id'].toString(),
        name: e['name'],
        createdAt: e['created_at'],
        userProfiles:
            users.where((element) => element.id == e['id'].toString()).toList(),
      );
    }).toList();

    /*

  1. Get rooms that the user is a member of
  2. Get members of those rooms
  3. Get user profiles of those members
  4. Map user profiles to members
  5. Map members to rooms
  6. Return rooms

  */

    /*
  1. Get rooms
  2. Get members
  3. Get users
  4. Map users to members
  5. Map members to rooms
  6. Return rooms
  */

    // print(membersRes);

    /* List<ChatRoom> rooms = roomsRes.map((e) {
    return ChatRoom(
      id: e['id'].toString(),
      name: e['name'],
      createdAt: e['created_at'],
    );
  }).toList(); */

    return List.empty();
  }

  static Future<dynamic> signUp(
      String email, String password, String username) async {
    final AuthResponse res =
        await client.auth.signUp(email: email, password: password);

    if (res.user == null) {
      return null;
    }

    final isTaken = await usernameIsTaken(username);

    if (isTaken) {
      throw Exception("Username is taken");
    }

    final UserProfile profile = await client.from('user_profile').insert({
      'id': res.user!.id,
      'name': username,
      'created_at': DateTime.now().toIso8601String(),
      'email': email,
    }).select();

    final List<String> values = [
      profile.id,
      profile.name,
      profile.email,
      profile.createdAt.toIso8601String()
    ];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('profile', values);

    return profile;
  }

  static Future<bool> usernameIsTaken(String username) async {
    final profile =
        await client.from('user_profile').select().eq('name', username);

    return profile.length > 0;
  }

  static Future<void> signIn(String email, String password) async {
    final AuthResponse res =
        await client.auth.signInWithPassword(email: email, password: password);

    /* final profileData =
        await client.from('user_profile').select().eq('id', res.user!.id); */

    /* final UserProfile profile = UserProfile(
      id: profileData[0]['id'].toString(),
      name: profileData[0]['name'],
      email: profileData[0]['email'],
      createdAt: profileData[0]['created_at'],
      image: profileData[0]['image'],
    ); */

    /* final List<String> values = [
      profile.id,
      profile.name,
      profile.email,
      profile.createdAt.toIso8601String(),
      profile.image
    ];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('profile', values); */

    /* print('///////////INSIDE SIGN IN//////////////');
    return profile; */
  }

  static Future<void> signOut() async {
    await client.auth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile');
  }

  static Future<dynamic> getAuthUser() async {
    client.auth.onAuthStateChange.listen((data) {
      print("authstateChange");
      print('\n');
      print('\n');
    });

    return client.auth.currentSession;
  }
}
