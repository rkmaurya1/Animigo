import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../config/app_colors.dart';
import '../../models/lobby_player_model.dart';
import 'dart:math' as math;

class RemoteCharacter extends PositionComponent {
  final String playerId;
  final String playerName;
  final String avatar;

  late TextComponent nameLabel;
  late RectangleComponent characterBody;
  String currentDirection = 'down';

  RemoteCharacter({
    required this.playerId,
    required this.playerName,
    required this.avatar,
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2.all(AppConstants.characterSize),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Character body
    characterBody = RectangleComponent(
      size: Vector2.all(AppConstants.characterSize),
      paint: Paint()
        ..shader = LinearGradient(
          colors: [AppColors.accent, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(
          Rect.fromLTWH(0, 0, AppConstants.characterSize, AppConstants.characterSize),
        ),
      anchor: Anchor.center,
    );
    add(characterBody);

    // Avatar icon
    final avatarIcon = TextComponent(
      text: _getAvatarEmoji(avatar),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 28,
        ),
      ),
      anchor: Anchor.center,
    );
    add(avatarIcon);

    // Name label
    nameLabel = TextComponent(
      text: playerName,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: Colors.black,
              blurRadius: 4,
            ),
          ],
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(0, -AppConstants.characterSize / 2 - 20),
    );
    add(nameLabel);
  }

  void updateFromModel(LobbyPlayerModel model) {
    // Smooth position interpolation
    final targetPosition = Vector2(model.x, model.y);
    final distance = position.distanceTo(targetPosition);

    if (distance > 5) {
      // Interpolate position for smooth movement
      position = position + (targetPosition - position) * 0.15;

      // Update direction and rotation
      if (model.direction != currentDirection) {
        currentDirection = model.direction;
        characterBody.angle = _getAngleForDirection(currentDirection);
      }
    }
  }

  String _getAvatarEmoji(String avatar) {
    switch (avatar) {
      case 'warrior':
        return '🛡️';
      case 'mage':
        return '🔮';
      case 'ninja':
        return '⚡';
      case 'samurai':
        return '🗡️';
      case 'archer':
        return '🏹';
      case 'healer':
        return '❤️';
      default:
        return '👤';
    }
  }

  double _getAngleForDirection(String dir) {
    switch (dir) {
      case 'right':
        return math.pi / 2;
      case 'down':
        return math.pi;
      case 'left':
        return -math.pi / 2;
      default: // up
        return 0;
    }
  }
}
