import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final client = Supabase.instance.client;

  static Future<void> signUp(
      String email, String password, String username) async {
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

  static Future<void> signIn(String email, String password) async {
    final AuthResponse res =
        await client.auth.signInWithPassword(email: email, password: password);

    if (res.user == null) {
      throw Exception("Unable to sign in");
    }

    final data =
        await client.from('user_profile').select().eq('id', res.user!.id);

    /* print('PROFILE: ID: ${data[0]['id']}');
    print('PROFILE: NAME: ${data[0]['name']}');
    print('PROFILE: CREATED_AT: ${data[0]['created_at']}');
    print('PROFILE: EMAIL: ${data[0]['email']}');
    print('PROFILE: IMAGE: ${data[0]['image']}'); */

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

  static Future<bool> _usernameIsTaken(String username) async {
    final profile =
        await client.from('user_profile').select().eq('name', username);

    return profile.length > 0;
  }
}
