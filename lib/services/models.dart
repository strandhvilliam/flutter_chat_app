import 'dart:convert';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String image;
  final DateTime createdAt;
  final List<UserProfile>? friends;

  UserProfile({
    this.id = '',
    this.name = '',
    this.email = '',
    this.image =
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
    DateTime? createdAt,
    this.friends,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserProfile.fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json);
    return UserProfile(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      image: data['image'] ??
          'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
      createdAt: DateTime.parse(data['created_at']),
      /* rooms: data['rooms'],
      friends: data['friends'], */
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'id: $id, name: $name, email: $email, image: $image, createdAt: $createdAt';
  }
}

class ChatRoom {
  final String id;
  final String name;
  final DateTime createdAt;
  final List<UserProfile>? members;

  ChatRoom({
    this.id = 'id',
    this.name = 'Room',
    DateTime? createdAt,
    this.members,
  }) : createdAt = createdAt ?? DateTime.now();

  @override
  String toString() {
    return 'id: $id, name: $name, createdAt: $createdAt, members: $members';
  }
}

class Message {
  final String id;
  final String content;
  final DateTime createdAt;
  final String? senderId;
  final String? roomId;

  Message({
    this.id = 'id',
    this.content = 'Message',
    DateTime? createdAt,
    this.senderId,
    this.roomId,
  }) : createdAt = createdAt ?? DateTime.now();
}
