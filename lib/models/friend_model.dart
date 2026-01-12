import 'package:cloud_firestore/cloud_firestore.dart';

class FriendModel {
  final String id;
  final String userId;
  final String friendId;
  final String friendUsername;
  final String friendAvatar;
  final String status; // 'pending', 'accepted'
  final DateTime createdAt;

  FriendModel({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.friendUsername,
    required this.friendAvatar,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'friendId': friendId,
      'friendUsername': friendUsername,
      'friendAvatar': friendAvatar,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory FriendModel.fromMap(Map<String, dynamic> map) {
    return FriendModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      friendId: map['friendId'] ?? '',
      friendUsername: map['friendUsername'] ?? '',
      friendAvatar: map['friendAvatar'] ?? 'warrior',
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
