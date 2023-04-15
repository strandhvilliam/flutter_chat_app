import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/supabase.dart' as supabase;
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/models.dart';

final List<UserProfile> friends = [
  UserProfile(
    id: '1234',
    name: 'John Doe2',
    email: '',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
  ),
  UserProfile(
    id: '1234',
    name: 'John Doe3',
    email: '',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
  ),
  UserProfile(
    id: '1234',
    name: 'John Doe4',
    email: '',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
  ),
  UserProfile(
    id: '1234',
    name: 'John Doe5',
    email: '',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
  ),
  UserProfile(
    id: '1234',
    name: 'John Doe6',
    email: '',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
  ),
  UserProfile(
    id: '1234',
    name: 'John Doe6',
    email: '',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
  ),
  UserProfile(
    id: '1234',
    name: 'John Doe6',
    email: '',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
  ),
  UserProfile(
    id: '1234',
    name: 'John Doe6',
    email: '',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
  ),
  UserProfile(
    id: '1234',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/chats'),
        ),
        title: const Text('Form'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 10),
            Text('Chat room',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            NewRoomForm(),
            SizedBox(height: 10),
            Text('Friends',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            FriendsList(),
          ],
        ),
      ),
    );
  }
}

class FriendsList extends StatelessWidget {
  const FriendsList({
    super.key,
  });

  _onProfilePressed() {
    print('Profile pressed');
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
              backgroundColor: Colors.blue,
              child: IconButton(
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                ),
                onPressed: _onProfilePressed,
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
                filled: true,
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
