import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_app/chats/chat_tile.dart';
import 'package:flutter_chat_app/services/models.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_chat_app/services/supabase.dart' as supabase;

final List<UserProfile> placeHolderMembers = List.of([
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

final List<UserProfile> placeHolderMembers1 = List.of([
  UserProfile(),
  UserProfile(),
]);

final List<ChatRoom> placeHolderRooms = List.of([
  ChatRoom(
    members: placeHolderMembers,
    name: 'Room 1',
  ),
  ChatRoom(
    members: placeHolderMembers,
    name: 'Room 2',
  ),
  ChatRoom(
    members: placeHolderMembers1,
    name: 'Room 3',
  ),
  ChatRoom(
    members: placeHolderMembers1,
    name: 'Room 4',
  ),
]);

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final _searchInputController = TextEditingController();
  late Future<List<ChatRoom>> _chatRooms;

  String _searchString = '';
  bool _showSearch = false;

  Widget _searchTextField() {
    return TextField(
      controller: _searchInputController,
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white, fontSize: 20),
      decoration: const InputDecoration(
        hintText: 'Search',
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
      ),
    );
  }

  Widget _defaultList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ChatTile(chatRoom: placeHolderRooms[index]);
      },
      itemCount: placeHolderRooms.length,
    );
  }

  Widget _searchList() {
    // TODO: Also search for members in room
    var searchList = placeHolderRooms
        .where((element) =>
            element.name.toLowerCase().contains(_searchString.toLowerCase()))
        .toList();
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ChatTile(chatRoom: searchList[index]);
      },
      itemCount: searchList.length,
    );
  }

  void _updateSearch() {
    setState(() {
      _searchString = _searchInputController.text;
    });
  }

  @override
  void dispose() {
    _searchInputController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _chatRooms = supabase.getChatRooms();
    _searchInputController.addListener(_updateSearch);
  }

  FutureBuilder<List<ChatRoom>> _chatRoomList() {
    return FutureBuilder<List<ChatRoom>>(
      future: _chatRooms,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ChatTile(chatRoom: snapshot.data![index]);
            },
            itemCount: snapshot.data!.length,
          );
        } else if (snapshot.hasError) {
          return const Text('Error');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: !_showSearch ? const Text('Chats') : _searchTextField(),
          actions: [
            !_showSearch
                ? IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => print('Add pressed'),
                  )
                : Container(),
            !_showSearch
                ? IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _showSearch = true;
                      });
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _showSearch = false;
                      });
                    },
                  ),
          ],
        ),
        body: !_showSearch ? _chatRoomList() : _searchList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => GoRouter.of(context).push('/new'),
          child: const Icon(Icons.question_answer_rounded),
        ));
  }
}
