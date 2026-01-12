import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/lobby_provider.dart';
import '../../services/chat_service.dart';
import '../../game/lobby_world.dart';
import '../../game/controllers/joystick_controller.dart';

class LobbyGameScreen extends StatefulWidget {
  const LobbyGameScreen({super.key});

  @override
  State<LobbyGameScreen> createState() => _LobbyGameScreenState();
}

class _LobbyGameScreenState extends State<LobbyGameScreen> {
  late LobbyWorld _lobbyWorld;
  final TextEditingController _chatController = TextEditingController();
  final ChatService _chatService = ChatService();
  bool _showChatInput = false;

  @override
  void initState() {
    super.initState();
    _initializeLobby();
  }

  void _initializeLobby() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final lobbyProvider = Provider.of<LobbyProvider>(context, listen: false);
    final user = authProvider.currentUser!;

    _lobbyWorld = LobbyWorld(
      currentUserId: user.uid,
      currentUsername: user.username,
      currentAvatar: user.avatar,
      onPositionUpdate: (x, y, direction, isMoving) {
        lobbyProvider.updatePosition(
          uid: user.uid,
          x: x,
          y: y,
          direction: direction,
          isMoving: isMoving,
        );
      },
      onSendMessage: (message) {
        _chatService.sendLobbyMessage(
          senderId: user.uid,
          senderName: user.username,
          content: message,
        );
      },
    );

    // Listen to lobby players
    lobbyProvider.listenToLobbyPlayers();
  }

  @override
  void dispose() {
    _chatController.dispose();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final lobbyProvider = Provider.of<LobbyProvider>(context, listen: false);

    // Leave lobby
    lobbyProvider.leaveLobby(authProvider.currentUser!.uid);
    authProvider.updateStatus(AppConstants.statusOnline);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Game world
          Consumer<LobbyProvider>(
            builder: (context, lobbyProvider, child) {
              // Update remote players in game
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _lobbyWorld.updateRemotePlayers(lobbyProvider.players);
              });

              return GameWidget(game: _lobbyWorld);
            },
          ),

          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),

                    // Players count
                    Consumer<LobbyProvider>(
                      builder: (context, lobbyProvider, child) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.card.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.people,
                                color: AppColors.online,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${lobbyProvider.players.length} players',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Chat button
                    IconButton(
                      icon: const Icon(Icons.chat, color: Colors.white),
                      onPressed: () {
                        setState(() => _showChatInput = !_showChatInput);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Chat input (when enabled)
          if (_showChatInput)
            Positioned(
              bottom: 140,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.card.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: AppColors.textTertiary),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        maxLength: AppConstants.maxChatMessageLength,
                        buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: AppColors.primary),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ),

          // Joystick
          Positioned(
            bottom: 20,
            left: 20,
            child: JoystickController(
              onDirectionChanged: (delta) {
                _lobbyWorld.playerCharacter.moveWithJoystick(
                  Vector2(delta.dx, delta.dy),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _chatController.text.trim();
    if (message.isEmpty) return;

    _lobbyWorld.onSendMessage(message);
    _chatController.clear();
    setState(() => _showChatInput = false);
  }
}
