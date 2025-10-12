import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/services/settings_service.dart';
import '../../../../shared/services/user_service.dart';

/// Advanced settings page
class AdvancedSettingsPage extends StatefulWidget {
  const AdvancedSettingsPage({super.key});

  @override
  State<AdvancedSettingsPage> createState() => _AdvancedSettingsPageState();
}

class _AdvancedSettingsPageState extends State<AdvancedSettingsPage> {
  final _settingsService = SettingsService();
  final _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E8EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B2C91),
        foregroundColor: Colors.white,
        title: const Text('Advanced Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Data & Privacy
            _buildSectionCard(
              title: 'Data & Privacy',
              children: [
                _buildSwitchTile(
                  title: 'Data Export',
                  subtitle: 'Allow exporting your financial data',
                  value: _settingsService.dataExportEnabled,
                  onChanged: _updateDataExport,
                ),
                _buildSwitchTile(
                  title: 'Analytics',
                  subtitle: 'Help improve the app with anonymous usage data',
                  value: _settingsService.analyticsEnabled,
                  onChanged: _updateAnalytics,
                ),
                _buildActionTile(
                  title: 'Export Data',
                  subtitle: 'Download all your data',
                  icon: Icons.download,
                  onTap: _exportData,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Account Management
            _buildSectionCard(
              title: 'Account Management',
              children: [
                _buildActionTile(
                  title: 'Deactivate Account',
                  subtitle: 'Temporarily disable your account',
                  icon: Icons.pause_circle_outline,
                  onTap: _showDeactivateDialog,
                  isDestructive: true,
                ),
                _buildActionTile(
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account and all data',
                  icon: Icons.delete_forever,
                  onTap: _showDeleteDialog,
                  isDestructive: true,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Warning Notice
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_outlined,
                    color: Colors.red.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Account deletion is permanent and cannot be undone. All your data will be lost.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red.shade700,
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

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged}) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF6B2C91),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : const Color(0xFF6B2C91),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _updateDataExport(bool value) {
    setState(() => _settingsService.updateAdvancedSettings(dataExportEnabled: value));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data export ${value ? 'enabled' : 'disabled'}'), backgroundColor: Colors.green));
  }

  void _updateAnalytics(bool value) {
    setState(() => _settingsService.updateAdvancedSettings(analyticsEnabled: value));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Analytics ${value ? 'enabled' : 'disabled'}'), backgroundColor: Colors.green));
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data export feature coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showDeactivateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Account'),
        content: const Text('Are you sure you want to deactivate your account? You can reactivate it anytime by logging in.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deactivateAccount();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to permanently delete your account? This action cannot be undone and all your data will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deactivateAccount() {
    _settingsService.updateAdvancedSettings(accountStatus: 'deactivated');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account deactivated successfully'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _deleteAccount() {
    _settingsService.updateAdvancedSettings(accountStatus: 'deleted');
    _userService.clearUserData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account deleted successfully'),
        backgroundColor: Colors.red,
      ),
    );
    context.go(RouteNames.login);
  }
}
