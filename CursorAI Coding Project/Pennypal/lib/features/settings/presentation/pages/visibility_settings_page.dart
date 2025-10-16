import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/services/settings_service.dart';
import '../../../../core/router/route_names.dart';

/// Visibility settings page
class VisibilitySettingsPage extends StatefulWidget {
  const VisibilitySettingsPage({super.key});

  @override
  State<VisibilitySettingsPage> createState() => _VisibilitySettingsPageState();
}

class _VisibilitySettingsPageState extends State<VisibilitySettingsPage> {
  final _settingsService = SettingsService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const Text('Visibility Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.settings),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Visibility Section
            _buildSectionCard(
              title: 'Profile Visibility',
              children: [
                _buildSwitchTile(
                  title: 'Profile Visibility',
                  subtitle: 'Allow others to view your profile',
                  value: _settingsService.profileVisibility,
                  onChanged: (value) => _updateProfileVisibility(value),
                ),
                _buildSwitchTile(
                  title: 'Activity Visibility',
                  subtitle: 'Show your recent activity to others',
                  value: _settingsService.activityVisibility,
                  onChanged: (value) => _updateActivityVisibility(value),
                ),
                _buildSwitchTile(
                  title: 'Achievement Visibility',
                  subtitle: 'Display your badges and achievements',
                  value: _settingsService.achievementVisibility,
                  onChanged: (value) => _updateAchievementVisibility(value),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Privacy Notice
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'These settings control who can see your profile information and activity. Changes take effect immediately.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeThumbColor: theme.colorScheme.primary,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _updateProfileVisibility(bool value) {
    setState(() {
      _settingsService.updateVisibilitySettings(profileVisibility: value);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile visibility ${value ? 'enabled' : 'disabled'}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _updateActivityVisibility(bool value) {
    setState(() {
      _settingsService.updateVisibilitySettings(activityVisibility: value);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Activity visibility ${value ? 'enabled' : 'disabled'}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _updateAchievementVisibility(bool value) {
    setState(() {
      _settingsService.updateVisibilitySettings(achievementVisibility: value);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Achievement visibility ${value ? 'enabled' : 'disabled'}'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
