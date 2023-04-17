import 'package:flutter/material.dart';
import 'package:flutter_chat_app/room/message_bar.dart';
import 'package:flutter_chat_app/services/models.dart';
import 'package:flutter_chat_app/services/supabase.dart' as supabase;
import 'package:flutter_chat_app/shared/utils.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key, required this.roomId});

  final String? roomId;

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late final Future<ChatRoom> _room;
  final List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _room = supabase.getSingleChatRoom(widget.roomId!);
  }

  final _stream = supabase.getChatStream();

  _sendMessage(String message) {
    supabase.sendMessage(widget.roomId!, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<ChatRoom>(
          future: _room,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.name);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return const Text('Loading...');
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: StreamBuilder(
                stream: _stream,
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    final List<dynamic> messages = snapshot.data!.map(
                      (element) {
                        return Message(
                          content: element['content'],
                          createdAt: DateTime.parse(element['created_at']),
                          id: element['id'],
                          roomId: element['room_id'],
                          senderId: element['sender_id'],
                        );
                      },
                    ).toList();
                    return ListView.separated(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return ChatBubble(message: messages[index]);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          ),
          MessageBar(onSend: _sendMessage),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
  });

  final Message message;

  bool _isOwnMessage(String userId) {
    return supabase.getCurrentUser()!.id == userId;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: _isOwnMessage(message.senderId!)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _isOwnMessage(message.senderId!)
                  ? Colors.teal
                  : Colors.grey[200],
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message.content,
              softWrap: true,
              style: TextStyle(
                color: _isOwnMessage(message.senderId!)
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ],
      ),
      subtitle: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: _isOwnMessage(message.senderId!)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 5, right: 10, bottom: 5, left: 10),
            child: Text(
              formatTimeStamp(message.createdAt),
            ),
          ),
        ],
      ),
    );
  }
}
