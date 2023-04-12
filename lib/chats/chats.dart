import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_app/chats/chat_tile.dart';
import 'package:flutter_chat_app/services/models.dart';

final List<UserProfile> placeHolderUserProfiles = List.of([
  UserProfile(),
  UserProfile(),
  UserProfile(),
  UserProfile(),
  UserProfile(),
  UserProfile(),
  UserProfile(),
  UserProfile(),
  UserProfile(),
]);

final List<UserProfile> placeHolderUserProfiles1 = List.of([
  UserProfile(),
  UserProfile(),
]);

final List<ChatRoom> placeHolderRooms = List.of([
  ChatRoom(
    userProfiles: placeHolderUserProfiles,
    name: 'Room 1',
  ),
  ChatRoom(
    userProfiles: placeHolderUserProfiles,
    name: 'Room 2',
  ),
  ChatRoom(
    userProfiles: placeHolderUserProfiles1,
    name: 'Room 3',
  ),
  ChatRoom(
    userProfiles: placeHolderUserProfiles1,
    name: 'Room 4',
  ),
]);

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chats'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => print('Search pressed'),
            ),
          ],
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return ChatTile(chatRoom: placeHolderRooms[index]);
          },
          itemCount: placeHolderRooms.length,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => print('New chat pressed'),
          child: const Icon(Icons.question_answer_rounded),
        ));
  }
}
