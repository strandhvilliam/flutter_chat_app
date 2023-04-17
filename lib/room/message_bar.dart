import 'package:flutter/material.dart';

class MessageBar extends StatefulWidget {
  const MessageBar({super.key, required this.onSend});

  final Function(String message) onSend;

  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  final TextEditingController _messageController = TextEditingController();

  _sendMessage() {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      _messageController.clear();
      widget.onSend(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,

      padding:
          const EdgeInsets.only(left: 25.0, top: 4.0, right: 15, bottom: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: const Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Type a message',
                    contentPadding: EdgeInsets.only(
                      left: 8.0,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              CircleAvatar(
                backgroundColor: Colors.teal,
                child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    _sendMessage();
                  },
                  icon: const Icon(Icons.send_rounded),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25.0,
          ),
        ],
      ),
    );
  }
}
