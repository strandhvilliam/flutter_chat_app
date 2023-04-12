class UserProfile {
  final String id;
  final String name;
  final String email;
  final String image;
  final DateTime createdAt;
  final List<ChatRoom>? rooms;
  final List<UserProfile>? friends;

  UserProfile({
    this.id = 'id',
    this.name = 'Username123',
    this.email = 'mail@mail.com',
    this.image =
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
    DateTime? createdAt,
    this.rooms,
    this.friends,
  }) : createdAt = createdAt ?? DateTime.now();
}

class ChatRoom {
  final String id;
  final String name;
  final DateTime createdAt;
  final List<UserProfile>? userProfiles;

  ChatRoom({
    this.id = 'id',
    this.name = 'Room',
    DateTime? createdAt,
    this.userProfiles,
  }) : createdAt = createdAt ?? DateTime.now();
}

class Message {
  final String id;
  final String message;
  final DateTime createdAt;
  final UserProfile? sender;
  final ChatRoom? room;

  Message({
    this.id = 'id',
    this.message = 'Message',
    DateTime? createdAt,
    this.sender,
    this.room,
  }) : createdAt = createdAt ?? DateTime.now();
}
