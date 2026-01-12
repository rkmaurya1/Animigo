import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../config/app_colors.dart';
import '../models/lobby_player_model.dart';
import 'components/player_character.dart';
import 'components/remote_character.dart';

class LobbyWorld extends FlameGame with HasCollisionDetection {
  final String currentUserId;
  final String currentUsername;
  final String currentAvatar;
  final Function(double, double, String, bool) onPositionUpdate;
  final Function(String) onSendMessage;

  late PlayerCharacter playerCharacter;
  final Map<String, RemoteCharacter> remotePlayers = {};

  LobbyWorld({
    required this.currentUserId,
    required this.currentUsername,
    required this.currentAvatar,
    required this.onPositionUpdate,
    required this.onSendMessage,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Set camera to follow player
    camera.viewfinder.anchor = Anchor.center;

    // Add background
    add(
      RectangleComponent(
        size: Vector2(AppConstants.lobbyWidth, AppConstants.lobbyHeight),
        paint: Paint()..color = const Color(0xFF1A1A2E),
        position: Vector2.zero(),
      ),
    );

    // Add grid lines for visual reference
    _addGridLines();

    // Add border
    add(
      RectangleComponent(
        size: Vector2(AppConstants.lobbyWidth, AppConstants.lobbyHeight),
        paint: Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..color = AppColors.primary.withOpacity(0.3),
        position: Vector2.zero(),
      ),
    );

    // Create and add player character
    playerCharacter = PlayerCharacter(
      playerId: currentUserId,
      playerName: currentUsername,
      avatar: currentAvatar,
      position: Vector2(
        AppConstants.lobbyWidth / 2,
        AppConstants.lobbyHeight / 2,
      ),
      onPositionUpdate: onPositionUpdate,
    );

    await add(playerCharacter);

    // Set camera to follow player
    camera.follow(playerCharacter);
  }

  void _addGridLines() {
    const gridSize = 50.0;

    // Vertical lines
    for (double x = 0; x <= AppConstants.lobbyWidth; x += gridSize) {
      add(
        RectangleComponent(
          size: Vector2(1, AppConstants.lobbyHeight),
          paint: Paint()..color = Colors.white.withOpacity(0.05),
          position: Vector2(x, 0),
        ),
      );
    }

    // Horizontal lines
    for (double y = 0; y <= AppConstants.lobbyHeight; y += gridSize) {
      add(
        RectangleComponent(
          size: Vector2(AppConstants.lobbyWidth, 1),
          paint: Paint()..color = Colors.white.withOpacity(0.05),
          position: Vector2(0, y),
        ),
      );
    }
  }

  // Update remote players
  void updateRemotePlayers(List<LobbyPlayerModel> players) {
    final currentPlayerIds = players.map((p) => p.uid).toSet();

    // Remove players who left
    remotePlayers.keys.toList().forEach((playerId) {
      if (!currentPlayerIds.contains(playerId)) {
        remotePlayers[playerId]?.removeFromParent();
        remotePlayers.remove(playerId);
      }
    });

    // Add or update players
    for (final player in players) {
      if (player.uid == currentUserId) continue;

      if (remotePlayers.containsKey(player.uid)) {
        // Update existing player
        remotePlayers[player.uid]!.updateFromModel(player);
      } else {
        // Add new player
        final remoteCharacter = RemoteCharacter(
          playerId: player.uid,
          playerName: player.username,
          avatar: player.avatar,
          position: Vector2(player.x, player.y),
        );

        remotePlayers[player.uid] = remoteCharacter;
        add(remoteCharacter);
      }
    }
  }

  // Get nearby players for proximity chat
  List<RemoteCharacter> getNearbyPlayers() {
    return remotePlayers.values.where((remote) {
      final distance = playerCharacter.position.distanceTo(remote.position);
      return distance <= AppConstants.proximityRadius;
    }).toList();
  }

  @override
  Color backgroundColor() => const Color(0xFF1A1A2E);
}
