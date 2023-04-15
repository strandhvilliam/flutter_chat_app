import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/supabase.dart';

import '../services/models.dart';

class ChatTile extends StatelessWidget {
  final ChatRoom chatRoom;

  const ChatTile({super.key, required this.chatRoom});

  List<UserProfile> getVisibleProfiles(List<UserProfile> members) {
    if (members.length > 3) {
      return members.sublist(0, 3);
    } else {
      return members;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //SupabaseService.client.fetchRooms();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  chatRoom.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: chatRoom.members != null &&
                                chatRoom.members!.isNotEmpty
                            ? getVisibleProfiles(chatRoom.members!)
                                .map((UserProfile profile) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: CircleAvatar(
                                    maxRadius: 12,
                                    foregroundImage: NetworkImage(
                                      profile.image,
                                    ),
                                  ),
                                );
                              }).toList()
                            : const <Widget>[],
                      )),
                  SizedBox(
                    width: 40,
                    child: Text(
                      chatRoom.members != null &&
                              chatRoom.members!.isNotEmpty &&
                              chatRoom.members!.length > 3
                          ? '+${chatRoom.members!.sublist(3, chatRoom.members!.length).length}'
                          : '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }
}
