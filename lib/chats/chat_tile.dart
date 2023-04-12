import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/supabase.dart';

import '../services/models.dart';

class ChatTile extends StatelessWidget {
  final ChatRoom chatRoom;

  const ChatTile({super.key, required this.chatRoom});

  List<UserProfile> getVisibleProfiles(List<UserProfile> userProfiles) {
    if (userProfiles.length > 3) {
      return userProfiles.sublist(0, 3);
    } else {
      return userProfiles;
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
                        children: chatRoom.userProfiles != null &&
                                chatRoom.userProfiles!.isNotEmpty
                            ? getVisibleProfiles(chatRoom.userProfiles!)
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
                      chatRoom.userProfiles != null &&
                              chatRoom.userProfiles!.isNotEmpty &&
                              chatRoom.userProfiles!.length > 3
                          ? '+${chatRoom.userProfiles!.sublist(3, chatRoom.userProfiles!.length).length}'
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
