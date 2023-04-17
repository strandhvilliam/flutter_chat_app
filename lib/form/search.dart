import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/models.dart';
import 'package:flutter_chat_app/services/supabase.dart' as supabase;
import 'package:flutter_chat_app/shared/utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();
  late Future<List<UserProfile>> _profiles;
  String searchString = '';

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _updateSearch() {
    setState(() {
      searchString = _inputController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    _profiles = supabase.getSearchProfiles();
    _inputController.addListener(_updateSearch);
  }

  FutureBuilder<List<UserProfile>> _searchList() {
    return FutureBuilder<List<UserProfile>>(
      future: _profiles,
      builder: (context, snapshot) {
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No results found'),
          );
        } else if (snapshot.hasData) {
          var resultList = snapshot.data!
              .where((element) => element.id != supabase.getCurrentUser()!.id)
              .where((element) => element.name
                  .toLowerCase()
                  .contains(searchString.toLowerCase()))
              .toList();

          if (searchString.isEmpty) {
            return const Center(
              child: Text("Search for a username"),
            );
          }
          return ListView.builder(
            itemCount: resultList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(resultList[index].name),
                trailing: AddFriendButton(userId: resultList[index].id),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Form(
          key: _formKey,
          child: TextFormField(
            controller: _inputController,
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
              filled: true,
              fillColor: Colors.black12,
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
            ),
          ),
        ),
      ),
      body: _searchList(),
    );
  }
}

class AddFriendButton extends StatefulWidget {
  const AddFriendButton({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<AddFriendButton> createState() => _AddFriendButtonState();
}

class _AddFriendButtonState extends State<AddFriendButton> {
  late bool _sentRequest;

  @override
  void initState() {
    super.initState();
    _sentRequest = false;
  }

  _onButtonClick() async {
    if (_sentRequest) {
      return;
    }
    try {
      await supabase.sendFriendRequest(widget.userId);
      setState(() {
        _sentRequest = true;
      });
    } catch (e) {
      context.showErrorSnackBar(message: 'Failed to send friend request');
    }
  }

  Future<bool> _checkIfFriend() async {
    final currentUserId = supabase.getCurrentUser()!.id;
    final profile = await supabase.getProfile(currentUserId);
    return profile.friends!.any((element) => element.id == widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 40,
      child: FutureBuilder<bool>(
        future: _checkIfFriend(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!) {
              return const OutlinedButton(
                onPressed: null,
                child: Text('Friends'),
              );
            } else {
              return _sentRequest
                  ? const OutlinedButton(
                      onPressed: null,
                      child: Text('Pending'),
                    )
                  : IconButton(
                      icon: const Icon(Icons.person_add),
                      onPressed: () => _onButtonClick());
            }
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        },
      ),
    );
  }
}
