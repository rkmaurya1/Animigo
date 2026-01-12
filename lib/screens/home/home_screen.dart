import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../config/constants.dart';
import 'tabs/friends_tab.dart';
import 'tabs/chats_tab.dart';
import '../lobby/lobby_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Update user status to online
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.updateStatus(AppConstants.statusOnline);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;

        return Scaffold(
          appBar: AppBar(
            title: Text(AppConstants.appName),
            actions: [
              // Profile button
              PopupMenuButton<String>(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                  ),
                  child: Icon(
                    _getAvatarIcon(user?.avatar ?? 'warrior'),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    enabled: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.username ?? 'User',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.online,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Online',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.online,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: AppColors.error),
                        SizedBox(width: 12),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'logout') {
                    _handleLogout();
                  }
                },
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: const [
                Tab(
                  icon: Icon(Icons.people),
                  text: 'Friends',
                ),
                Tab(
                  icon: Icon(Icons.chat),
                  text: 'Chats',
                ),
                Tab(
                  icon: Icon(Icons.videogame_asset),
                  text: 'Lobby',
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: const [
              FriendsTab(),
              ChatsTab(),
              LobbyEntryScreen(),
            ],
          ),
        );
      },
    );
  }

  IconData _getAvatarIcon(String avatar) {
    switch (avatar) {
      case 'warrior':
        return Icons.shield;
      case 'mage':
        return Icons.auto_fix_high;
      case 'ninja':
        return Icons.flash_on;
      case 'samurai':
        return Icons.sports_martial_arts;
      case 'archer':
        return Icons.control_camera;
      case 'healer':
        return Icons.favorite;
      default:
        return Icons.person;
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.signOut();
              if (!mounted) return;
              Navigator.of(context).pushReplacementNamed('/');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
