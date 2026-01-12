import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../config/app_colors.dart';
import 'dart:math' as math;

class PlayerCharacter extends PositionComponent with HasGameRef {
  final String playerId;
  final String playerName;
  final String avatar;
  final Function(double, double, String, bool) onPositionUpdate;

  Vector2 velocity = Vector2.zero();
  String direction = 'down';
  bool isMoving = false;

  late TextComponent nameLabel;
  late RectangleComponent characterBody;
  late CircleComponent statusIndicator;

  PlayerCharacter({
    required this.playerId,
    required this.playerName,
    required this.avatar,
    required Vector2 position,
    required this.onPositionUpdate,
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
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(
          Rect.fromLTWH(0, 0, AppConstants.characterSize, AppConstants.characterSize),
        ),
      anchor: Anchor.center,
    );
    add(characterBody);

    // Avatar icon (simplified)
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

    // Status indicator (glow effect)
    statusIndicator = CircleComponent(
      radius: AppConstants.characterSize / 2 + 4,
      paint: Paint()
        ..color = AppColors.online.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
      anchor: Anchor.center,
    );
    add(statusIndicator);

    // Name label above character
    nameLabel = TextComponent(
      text: playerName,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
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

  @override
  void update(double dt) {
    super.update(dt);

    if (velocity.length > 0) {
      isMoving = true;

      // Update position
      position += velocity * dt;

      // Keep within bounds
      position.x = position.x.clamp(
        AppConstants.characterSize / 2,
        AppConstants.lobbyWidth - AppConstants.characterSize / 2,
      );
      position.y = position.y.clamp(
        AppConstants.characterSize / 2,
        AppConstants.lobbyHeight - AppConstants.characterSize / 2,
      );

      // Update direction
      if (velocity.x.abs() > velocity.y.abs()) {
        direction = velocity.x > 0 ? 'right' : 'left';
      } else {
        direction = velocity.y > 0 ? 'down' : 'up';
      }

      // Rotate character based on direction
      characterBody.angle = _getAngleForDirection(direction);

      // Notify position change
      onPositionUpdate(position.x, position.y, direction, true);
    } else {
      if (isMoving) {
        isMoving = false;
        onPositionUpdate(position.x, position.y, direction, false);
      }
    }
  }

  void moveWithJoystick(Vector2 joystickDelta) {
    if (joystickDelta.length > 0) {
      velocity = joystickDelta.normalized() * AppConstants.characterSpeed;
    } else {
      velocity = Vector2.zero();
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
