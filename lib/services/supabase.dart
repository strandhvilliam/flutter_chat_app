import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final client = Supabase.instance.client;

Future<void> signUp(String email, String password, String username) async {
  // Create authenticated user
  final AuthResponse res =
      await client.auth.signUp(email: email, password: password);

  if (res.user == null) {
    throw Exception("Unable to create user");
  }
  // TODO: Check if username is taken
  // Insert user profile in database
  await client.from('user_profile').insert({
    'id': res.user!.id,
    'name': username,
    'created_at': res.user!.createdAt,
    'email': email,
  });

  final profileData = {
    'id': res.user!.id,
    'name': username,
    'created_at': res.user!.createdAt,
    'email': email,
    'image': null,
  };

  final jsonText = jsonEncode(profileData);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('profile', jsonText);
}

Future<void> signIn(String email, String password) async {
  final AuthResponse res =
      await client.auth.signInWithPassword(email: email, password: password);

  if (res.user == null) {
    throw Exception("Unable to sign in");
  }

  final data =
      await client.from('user_profile').select().eq('id', res.user!.id);

  final profileData = {
    'id': data[0]['id'],
    'name': data[0]['name'],
    'created_at': data[0]['created_at'],
    'email': data[0]['email'],
    'image': data[0]['image'],
  };

  final jsonText = jsonEncode(profileData);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('profile', jsonText);
}

Future<void> signOut() async {
  await client.auth.signOut();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('profile');
}

Future<List<ChatRoom>> getChatRooms() async {
  final currentUserId = client.auth.currentUser!.id;

  final List<dynamic> roomIdsRef = await client
      .from('member')
      .select('room_id')
      .eq('user_id', currentUserId);

  final List<String> roomIds = roomIdsRef.map((data) {
    return data['room_id'] as String;
  }).toList();

  final List<dynamic> roomsRef =
      await client.from('chat_room').select().in_('id', roomIds);

  final List<dynamic> roomMembersRef =
      await client.from('member').select().in_('room_id', roomIds);

  final List<String> userIds = roomMembersRef.map((data) {
    return data['user_id'] as String;
  }).toList();

  final List<dynamic> usersRef =
      await client.from('user_profile').select().in_('id', userIds);

  final List<UserProfile> users = usersRef.map((data) {
    return UserProfile(
      id: data['id'] as String,
      name: data['name'] as String,
      createdAt: DateTime.parse(data['created_at'] as String),
      email: data['email'] as String,
      image: data['image'] as String? ??
          'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
    );
  }).toList();

  final List<ChatRoom> chatRooms = roomsRef.map((data) {
    return ChatRoom(
      id: data['id'],
      name: data['name'],
      createdAt: DateTime.parse(data['created_at']),
      members: users.where((user) {
        return roomMembersRef.any((member) {
          return member['room_id'] == data['id'] as String &&
              member['user_id'] as String == user.id;
        });
      }).toList(),
    );
  }).toList();

  print("in getChatRooms:");
  return chatRooms;
}
