import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String avatar;
  final String status; // online, offline, in_lobby
  final DateTime createdAt;
  final DateTime lastSeen;

  UserModel({
    required this.uid,
    required this.username,
    required this.avatar,
    required this.status,
    required this.createdAt,
    required this.lastSeen,
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'avatar': avatar,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastSeen': Timestamp.fromDate(lastSeen),
    };
  }

  // Create from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      avatar: map['avatar'] ?? 'warrior',
      status: map['status'] ?? 'offline',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastSeen: (map['lastSeen'] as Timestamp).toDate(),
    );
  }

  // Copy with method for updates
  UserModel copyWith({
    String? uid,
    String? username,
    String? avatar,
    String? status,
    DateTime? createdAt,
    DateTime? lastSeen,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
