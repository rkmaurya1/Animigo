import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../services/user_service.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/user_model.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  final UserService _userService = UserService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUserId = authProvider.currentUser?.uid;

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
            ),
            onChanged: (value) => setState(() {}),
          ),
        ),

        // Users list
        Expanded(
          child: StreamBuilder<List<UserModel>>(
            stream: _userService.getOnlineUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 80,
                        color: AppColors.textTertiary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No users online',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textTertiary,
                            ),
                      ),
                    ],
                  ),
                );
              }

              // Filter out current user and apply search
              final users = snapshot.data!
                  .where((user) => user.uid != currentUserId)
                  .where((user) {
                if (_searchController.text.isEmpty) return true;
                return user.username
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase());
              }).toList();

              if (users.isEmpty) {
                return Center(
                  child: Text(
                    'No users found',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return _buildUserCard(user);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(UserModel user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ),
          ),
          child: Icon(
            _getAvatarIcon(user.avatar),
            color: Colors.white,
          ),
        ),
        title: Text(
          user.username,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getStatusColor(user.status),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              _getStatusText(user.status),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getStatusColor(user.status),
                  ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.chat, color: AppColors.primary),
          onPressed: () {
            // TODO: Navigate to chat screen
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Chat with ${user.username}'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'online':
        return AppColors.online;
      case 'in_lobby':
        return AppColors.secondary;
      default:
        return AppColors.offline;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'online':
        return 'Online';
      case 'in_lobby':
        return 'In Lobby';
      default:
        return 'Offline';
    }
  }
}
