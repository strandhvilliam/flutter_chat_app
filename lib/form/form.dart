import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/supabase.dart' as supabase;
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/models.dart';

final List<UserProfile> friends = [
  UserProfile(
    id: '12341',
    name: 'John Doe2',
    email: '',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
  ),
  UserProfile(
    id: '12342',
    name: 'John Doe3',
    email: '',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
  ),
  UserProfile(
    id: '12343',
    name: 'John Doe4',
    email: '',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
  ),
  UserProfile(
    id: '12344',
    name: 'John Doe5',
    email: '',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
  ),
  UserProfile(
    id: '12345',
    name: 'John Doe6',
    email: '',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
  ),
  UserProfile(
    id: '12346',
    name: 'John Doe6',
    email: '',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
  ),
  UserProfile(
    id: '12347',
    name: 'John Doe6',
    email: '',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
  ),
  UserProfile(
    id: '12348',
    name: 'John Doe6',
    email: '',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
  ),
  UserProfile(
    id: '12349',
    name: 'John Doe6',
    email: '',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
  ),
];

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  onAddToRoom(String id) {
    print('add to room');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/chats'),
        ),
        title: const Text('Create New Room'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 10),
            const NewRoomForm(),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Friends',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    context.push('/search');
                  },
                  child: const Text('Add Friend'),
                ),
              ],
            ),
            const Divider(
              height: 10,
              thickness: 1,
              color: Colors.grey,
            ),
            FriendsList(onAddToRoom: onAddToRoom),
          ],
        ),
      ),
    );
  }
}

class FriendsList extends StatefulWidget {
  final Function(String id) onAddToRoom;
  const FriendsList({
    super.key,
    required this.onAddToRoom,
  });

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  final List<String> _selectedFriends = [];

  void _updateIcon(String id) {
    setState(() {
      _selectedFriends.contains(id)
          ? _selectedFriends.remove(id)
          : _selectedFriends.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(friends[index].image),
            ),
            title: Text(friends[index].name),
            trailing: CircleAvatar(
              backgroundColor: _selectedFriends.contains(friends[index].id)
                  ? Colors.blue
                  : Colors.grey,
              child: IconButton(
                icon: Icon(
                  _selectedFriends.contains(friends[index].id)
                      ? Icons.check
                      : Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  widget.onAddToRoom(friends[index].id);
                  _updateIcon(friends[index].id);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class NewRoomForm extends StatefulWidget {
  const NewRoomForm({
    super.key,
  });

  @override
  State<NewRoomForm> createState() => _NewRoomFormState();
}

class _NewRoomFormState extends State<NewRoomForm> {
  final _roomNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _createChatRoom() async {
    List<ChatRoom> rooms = await supabase.getChatRooms();
    rooms.forEach((element) {
      print(element.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
              controller: _roomNameController,
              decoration: const InputDecoration(
                filled: false,
                hintText: 'Enter a title...',
                labelText: 'Room Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Room name cannot be empty';
                }
                return null;
              }),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _createChatRoom();
              }
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                const Size(double.infinity, 50),
              ),
            ),
            child: const Text('Create'),
          ),
        ]
            .expand(
              (widget) => [
                widget,
                const SizedBox(
                  height: 24,
                )
              ],
            )
            .toList(),
      ),
    );
  }
}
