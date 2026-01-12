import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/lobby_provider.dart';
import 'lobby_game_screen.dart';

class LobbyEntryScreen extends StatelessWidget {
  const LobbyEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.lobbyBackground,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lobby preview image placeholder
            Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.public,
                      size: 80,
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.overlay,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.people,
                            color: AppColors.online,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          StreamBuilder<List>(
                            stream: Provider.of<LobbyProvider>(context, listen: false)
                                .listenToLobbyPlayers() as Stream<List>?,
                            builder: (context, snapshot) {
                              final playerCount = snapshot.data?.length ?? 0;
                              return Text(
                                '$playerCount players online',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 800.ms)
                .scale(begin: const Offset(0.8, 0.8)),

            const SizedBox(height: 40),

            // Title
            Text(
              'Enter Anime World',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            )
                .animate()
                .fadeIn(delay: 200.ms)
                .slideY(begin: 0.3, end: 0),

            const SizedBox(height: 12),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Move your character, meet friends, and chat in real-time!',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms)
                .slideY(begin: 0.3, end: 0),

            const SizedBox(height: 40),

            // Enter button
            ElevatedButton(
              onPressed: () => _enterLobby(context, user!),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 18,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.login, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Enter Lobby',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 600.ms)
                .scale(begin: const Offset(0.8, 0.8))
                .shimmer(delay: 1000.ms, duration: 2000.ms),

            const SizedBox(height: 24),

            // Game controls info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.textTertiary.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.videogame_asset,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'How to Play',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• Use joystick to move your character\n'
                    '• Get close to friends to chat\n'
                    '• Chat bubbles appear above characters',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 800.ms)
                .slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }

  void _enterLobby(BuildContext context, user) async {
    final lobbyProvider = Provider.of<LobbyProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Join lobby
    await lobbyProvider.joinLobby(
      uid: user.uid,
      username: user.username,
      avatar: user.avatar,
    );

    // Update status
    await authProvider.updateStatus(AppConstants.statusInLobby);

    if (!context.mounted) return;

    // Navigate to lobby game
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LobbyGameScreen(),
      ),
    );
  }
}
