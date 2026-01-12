import 'package:cloud_firestore/cloud_firestore.dart';

class LobbyPlayerModel {
  final String uid;
  final String username;
  final String avatar;
  final double x; // Position X in lobby
  final double y; // Position Y in lobby
  final String direction; // 'left', 'right', 'up', 'down'
  final bool isMoving;
  final DateTime lastUpdate;

  LobbyPlayerModel({
    required this.uid,
    required this.username,
    required this.avatar,
    required this.x,
    required this.y,
    this.direction = 'down',
    this.isMoving = false,
    required this.lastUpdate,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'avatar': avatar,
      'x': x,
      'y': y,
      'direction': direction,
      'isMoving': isMoving,
      'lastUpdate': Timestamp.fromDate(lastUpdate),
    };
  }

  factory LobbyPlayerModel.fromMap(Map<String, dynamic> map) {
    return LobbyPlayerModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      avatar: map['avatar'] ?? 'warrior',
      x: (map['x'] ?? 0).toDouble(),
      y: (map['y'] ?? 0).toDouble(),
      direction: map['direction'] ?? 'down',
      isMoving: map['isMoving'] ?? false,
      lastUpdate: (map['lastUpdate'] as Timestamp).toDate(),
    );
  }

  LobbyPlayerModel copyWith({
    String? uid,
    String? username,
    String? avatar,
    double? x,
    double? y,
    String? direction,
    bool? isMoving,
    DateTime? lastUpdate,
  }) {
    return LobbyPlayerModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      x: x ?? this.x,
      y: y ?? this.y,
      direction: direction ?? this.direction,
      isMoving: isMoving ?? this.isMoving,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  // Calculate distance to another player
  double distanceTo(LobbyPlayerModel other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return (dx * dx + dy * dy);
  }
}
