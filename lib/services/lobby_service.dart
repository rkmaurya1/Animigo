import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lobby_player_model.dart';
import '../config/constants.dart';

class LobbyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Join lobby (add player to lobby collection)
  Future<void> joinLobby({
    required String uid,
    required String username,
    required String avatar,
  }) async {
    try {
      final player = LobbyPlayerModel(
        uid: uid,
        username: username,
        avatar: avatar,
        x: AppConstants.lobbyWidth / 2,
        y: AppConstants.lobbyHeight / 2,
        direction: 'down',
        isMoving: false,
        lastUpdate: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.lobbyPlayersCollection)
          .doc(uid)
          .set(player.toMap());
    } catch (e) {
      print('Join lobby error: $e');
    }
  }

  // Leave lobby
  Future<void> leaveLobby(String uid) async {
    try {
      await _firestore
          .collection(AppConstants.lobbyPlayersCollection)
          .doc(uid)
          .delete();
    } catch (e) {
      print('Leave lobby error: $e');
    }
  }

  // Update player position
  Future<void> updatePosition({
    required String uid,
    required double x,
    required double y,
    required String direction,
    required bool isMoving,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.lobbyPlayersCollection)
          .doc(uid)
          .update({
        'x': x,
        'y': y,
        'direction': direction,
        'isMoving': isMoving,
        'lastUpdate': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Update position error: $e');
    }
  }

  // Get all players in lobby
  Stream<List<LobbyPlayerModel>> getLobbyPlayers() {
    return _firestore
        .collection(AppConstants.lobbyPlayersCollection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => LobbyPlayerModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Get nearby players (for proximity chat)
  Stream<List<LobbyPlayerModel>> getNearbyPlayers(String currentUserId) {
    return getLobbyPlayers().map((players) {
      final currentPlayer = players.firstWhere(
        (p) => p.uid == currentUserId,
        orElse: () => LobbyPlayerModel(
          uid: '',
          username: '',
          avatar: '',
          x: 0,
          y: 0,
          lastUpdate: DateTime.now(),
        ),
      );

      if (currentPlayer.uid.isEmpty) return [];

      return players.where((player) {
        if (player.uid == currentUserId) return false;

        final distance = currentPlayer.distanceTo(player);
        return distance <= AppConstants.proximityRadius * AppConstants.proximityRadius;
      }).toList();
    });
  }

  // Clean up inactive players (optional, can be run periodically)
  Future<void> cleanupInactivePlayers() async {
    try {
      final cutoffTime = DateTime.now().subtract(const Duration(minutes: 5));
      final snapshot = await _firestore
          .collection(AppConstants.lobbyPlayersCollection)
          .where('lastUpdate', isLessThan: Timestamp.fromDate(cutoffTime))
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Cleanup inactive players error: $e');
    }
  }
}
