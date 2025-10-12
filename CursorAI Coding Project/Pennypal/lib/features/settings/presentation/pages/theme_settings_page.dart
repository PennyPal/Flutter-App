import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/services/settings_service.dart';

/// Theme settings page
class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  final _settingsService = SettingsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E8EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B2C91),
        foregroundColor: Colors.white,
        title: const Text('Theme Settings'),
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
            // Theme Mode Section
            _buildSectionCard(
              title: 'Theme Mode',
              children: [
                _buildRadioTile(
                  title: 'Light',
                  subtitle: 'Always use light theme',
                  value: 'light',
                  groupValue: _settingsService.themeMode,
                  onChanged: (value) => _updateThemeMode(value!),
                ),
                _buildRadioTile(
                  title: 'Dark',
                  subtitle: 'Always use dark theme',
                  value: 'dark',
                  groupValue: _settingsService.themeMode,
                  onChanged: (value) => _updateThemeMode(value!),
                ),
                _buildRadioTile(
                  title: 'System',
                  subtitle: 'Follow system theme',
                  value: 'system',
                  groupValue: _settingsService.themeMode,
                  onChanged: (value) => _updateThemeMode(value!),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Accent Color Section
            _buildSectionCard(
              title: 'Accent Color',
              children: [
                _buildColorOption('purple', 'Purple', const Color(0xFF6B2C91)),
                _buildColorOption('blue', 'Blue', const Color(0xFF3B82F6)),
                _buildColorOption('green', 'Green', const Color(0xFF10B981)),
                _buildColorOption('red', 'Red', const Color(0xFFEF4444)),
                _buildColorOption('orange', 'Orange', const Color(0xFFF59E0B)),
              ],
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRadioTile({
    required String title,
    required String subtitle,
    required String value,
    required String groupValue,
    required ValueChanged<String> onChanged,
  }) {
    return RadioListTile<String>(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      groupValue: groupValue,
      onChanged: (value) => onChanged(value!),
      activeColor: const Color(0xFF6B2C91),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildColorOption(String value, String label, Color color) {
    final isSelected = _settingsService.accentColor == value;
    
    return GestureDetector(
      onTap: () => _updateAccentColor(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.black,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check,
                color: color,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _updateThemeMode(String mode) {
    setState(() {
      _settingsService.updateThemeSettings(themeMode: mode);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Theme mode updated'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _updateAccentColor(String color) {
    setState(() {
      _settingsService.updateThemeSettings(accentColor: color);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Accent color updated'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
