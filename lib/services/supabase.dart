import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
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

  static Future<dynamic> signUp(String email, String password) async {
    final AuthResponse res =
        await client.auth.signUp(email: email, password: password);

    return res.user;
  }

  static Future<dynamic> signIn(String email, String password) async {
    final res =
        await client.auth.signInWithPassword(email: email, password: password);

    print(res.user!.id);

    return res.user;
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static Future<dynamic> getAuthUser() async {
    client.auth.onAuthStateChange.listen((data) {
      // print(data);
    });

    return client.auth.currentSession;
  }
}
