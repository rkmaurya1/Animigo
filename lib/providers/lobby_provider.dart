import 'package:flutter/foundation.dart';
import '../models/lobby_player_model.dart';
import '../services/lobby_service.dart';

class LobbyProvider with ChangeNotifier {
  final LobbyService _lobbyService = LobbyService();

  List<LobbyPlayerModel> _players = [];
  bool _isInLobby = false;

  List<LobbyPlayerModel> get players => _players;
  bool get isInLobby => _isInLobby;

  // Join lobby
  Future<void> joinLobby({
    required String uid,
    required String username,
    required String avatar,
  }) async {
    try {
      await _lobbyService.joinLobby(
        uid: uid,
        username: username,
        avatar: avatar,
      );
      _isInLobby = true;
      notifyListeners();
    } catch (e) {
      print('Join lobby error: $e');
    }
  }

  // Leave lobby
  Future<void> leaveLobby(String uid) async {
    try {
      await _lobbyService.leaveLobby(uid);
      _isInLobby = false;
      _players = [];
      notifyListeners();
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
      await _lobbyService.updatePosition(
        uid: uid,
        x: x,
        y: y,
        direction: direction,
        isMoving: isMoving,
      );
    } catch (e) {
      print('Update position error: $e');
    }
  }

  // Listen to lobby players
  void listenToLobbyPlayers() {
    _lobbyService.getLobbyPlayers().listen((players) {
      _players = players;
      notifyListeners();
    });
  }

  // Get nearby players
  Stream<List<LobbyPlayerModel>> getNearbyPlayers(String currentUserId) {
    return _lobbyService.getNearbyPlayers(currentUserId);
  }
}
