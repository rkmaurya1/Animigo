import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  String _selectedAvatar = AppConstants.avatarTypes[0];
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signUp(
      username: _usernameController.text.trim(),
      avatar: _selectedAvatar,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Sign up failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              AppColors.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Welcome text
                  Text(
                    'Welcome to',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: -0.3, end: 0),

                  const SizedBox(height: 8),

                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 600.ms)
                      .slideY(begin: -0.3, end: 0)
                      .shimmer(delay: 800.ms, duration: 1500.ms),

                  const SizedBox(height: 60),

                  // Username input
                  Text(
                    'Choose your username',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Enter unique username',
                      prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Username is required';
                      }
                      if (value.trim().length < 3) {
                        return 'Username must be at least 3 characters';
                      }
                      if (value.trim().length > 20) {
                        return 'Username must be less than 20 characters';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.2, end: 0),

                  const SizedBox(height: 40),

                  // Avatar selection
                  Text(
                    'Select your character',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ).animate().fadeIn(delay: 600.ms),

                  const SizedBox(height: 20),

                  // Avatar grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: AppConstants.avatarTypes.length,
                    itemBuilder: (context, index) {
                      final avatar = AppConstants.avatarTypes[index];
                      final isSelected = _selectedAvatar == avatar;

                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedAvatar = avatar);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryLight
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.4),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getAvatarIcon(avatar),
                                size: 48,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                avatar[0].toUpperCase() + avatar.substring(1),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(delay: (700 + index * 100).ms)
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              duration: 400.ms,
                            ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Sign up button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: AppColors.primary,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Enter Animigo',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  )
                      .animate()
                      .fadeIn(delay: 1200.ms)
                      .slideY(begin: 0.3, end: 0)
                      .shimmer(delay: 1500.ms, duration: 2000.ms),
                ],
              ),
            ),
          ),
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
}
