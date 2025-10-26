import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/services/user_service.dart';

/// Settings page matching the provided design
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              context.go(RouteNames.home);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Account Setting
            _buildSettingsCard(
              context,
              icon: Icons.person_outline,
              title: 'Account Setting',
              description: 'Manage your profile details, email, and password',
              onTap: () => context.push('${RouteNames.profileEdit}?from=settings'),
            ),
            
            const SizedBox(height: 12),
            
            // Theme
            _buildSettingsCard(
              context,
              icon: Icons.palette_outlined,
              title: 'Theme',
              description: 'Switch between light, dark, or colored themes',
              onTap: () => context.go(RouteNames.themeSettings),
            ),
            
            const SizedBox(height: 12),
            
            // Visibility
            _buildSettingsCard(
              context,
              icon: Icons.visibility_outlined,
              title: 'Visibility',
              description: 'Control who can view your profile and activity',
              onTap: () => context.go(RouteNames.visibilitySettings),
            ),
            
            const SizedBox(height: 12),
            
            // Location Access
            _buildSettingsCard(
              context,
              icon: Icons.location_on_outlined,
              title: 'Location Access',
              description: 'Allow or restrict location-based content & features',
              onTap: () => context.go(RouteNames.locationSettings),
            ),
            
            const SizedBox(height: 12),
            
            // Notifications
            _buildSettingsCard(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              description: 'Choose what alerts you receive and how often',
              onTap: () => context.go(RouteNames.notificationSettings),
            ),
            
            const SizedBox(height: 12),
            
            // Advanced
            _buildSettingsCard(
              context,
              icon: Icons.settings_outlined,
              title: 'Advanced',
              description: 'Deactivate or permanently delete your account',
              onTap: () => context.go(RouteNames.advancedSettings),
            ),
            
            const SizedBox(height: 12),
            
            // Log-out
            _buildSettingsCard(
              context,
              icon: Icons.logout,
              title: 'Log-out',
              description: 'Sign out of your account',
              onTap: () => _showLogoutDialog(context),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
            child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).round()),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Clear user data and navigate to login
              UserService().clearUserData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Successfully logged out'),
                  backgroundColor: Colors.green,
                ),
              );
              context.go(RouteNames.login);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}