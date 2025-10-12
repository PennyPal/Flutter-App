import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/services/settings_service.dart';

/// Notification settings page
class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final _settingsService = SettingsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E8EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B2C91),
        foregroundColor: Colors.white,
        title: const Text('Notification Settings'),
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
            // Notification Types
            _buildSectionCard(
              title: 'Notification Types',
              children: [
                _buildSwitchTile(
                  title: 'Push Notifications',
                  subtitle: 'Receive notifications on your device',
                  value: _settingsService.pushNotifications,
                  onChanged: _updatePushNotifications,
                ),
                _buildSwitchTile(
                  title: 'Email Notifications',
                  subtitle: 'Receive notifications via email',
                  value: _settingsService.emailNotifications,
                  onChanged: _updateEmailNotifications,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Alert Types
            _buildSectionCard(
              title: 'Alert Types',
              children: [
                _buildSwitchTile(
                  title: 'Transaction Alerts',
                  subtitle: 'Get notified about new transactions',
                  value: _settingsService.transactionAlerts,
                  onChanged: _updateTransactionAlerts,
                ),
                _buildSwitchTile(
                  title: 'Budget Alerts',
                  subtitle: 'Get notified when approaching budget limits',
                  value: _settingsService.budgetAlerts,
                  onChanged: _updateBudgetAlerts,
                ),
                _buildSwitchTile(
                  title: 'Goal Alerts',
                  subtitle: 'Get notified about goal progress',
                  value: _settingsService.goalAlerts,
                  onChanged: _updateGoalAlerts,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Frequency
            _buildSectionCard(
              title: 'Notification Frequency',
              children: [
                _buildRadioTile('immediate', 'Immediate', 'Send notifications as they happen'),
                _buildRadioTile('daily', 'Daily Summary', 'Send a daily summary of notifications'),
                _buildRadioTile('weekly', 'Weekly Summary', 'Send a weekly summary of notifications'),
              ],
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

  Widget _buildRadioTile(String value, String title, String subtitle) {
    return RadioListTile<String>(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      groupValue: _settingsService.notificationFrequency,
      onChanged: (value) => _updateNotificationFrequency(value!),
      activeColor: const Color(0xFF6B2C91),
      contentPadding: EdgeInsets.zero,
    );
  }

  void _updatePushNotifications(bool value) {
    setState(() => _settingsService.updateNotificationSettings(pushNotifications: value));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Push notifications ${value ? 'enabled' : 'disabled'}'), backgroundColor: Colors.green));
  }

  void _updateEmailNotifications(bool value) {
    setState(() => _settingsService.updateNotificationSettings(emailNotifications: value));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email notifications ${value ? 'enabled' : 'disabled'}'), backgroundColor: Colors.green));
  }

  void _updateTransactionAlerts(bool value) {
    setState(() => _settingsService.updateNotificationSettings(transactionAlerts: value));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transaction alerts ${value ? 'enabled' : 'disabled'}'), backgroundColor: Colors.green));
  }

  void _updateBudgetAlerts(bool value) {
    setState(() => _settingsService.updateNotificationSettings(budgetAlerts: value));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Budget alerts ${value ? 'enabled' : 'disabled'}'), backgroundColor: Colors.green));
  }

  void _updateGoalAlerts(bool value) {
    setState(() => _settingsService.updateNotificationSettings(goalAlerts: value));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Goal alerts ${value ? 'enabled' : 'disabled'}'), backgroundColor: Colors.green));
  }

  void _updateNotificationFrequency(String frequency) {
    setState(() => _settingsService.updateNotificationSettings(notificationFrequency: frequency));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notification frequency updated to $frequency'), backgroundColor: Colors.green));
  }
}
