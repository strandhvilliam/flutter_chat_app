import 'package:flutter/material.dart';

class MessageBar extends StatefulWidget {
  const MessageBar({super.key});

  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
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
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
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
                backgroundColor: Colors.lightBlue,
                child: IconButton(
                  color: Colors.white,
                  onPressed: () {},
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
