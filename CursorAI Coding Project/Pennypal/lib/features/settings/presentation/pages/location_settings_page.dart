import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/services/settings_service.dart';

/// Location settings page
class LocationSettingsPage extends StatefulWidget {
  const LocationSettingsPage({super.key});

  @override
  State<LocationSettingsPage> createState() => _LocationSettingsPageState();
}

class _LocationSettingsPageState extends State<LocationSettingsPage> {
  final _settingsService = SettingsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E8EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B2C91),
        foregroundColor: Colors.white,
        title: const Text('Location Settings'),
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
            _buildSectionCard(
              title: 'Location Access',
              children: [
                _buildSwitchTile(
                  title: 'Enable Location',
                  subtitle: 'Allow app to access your location',
                  value: _settingsService.locationEnabled,
                  onChanged: _updateLocationEnabled,
                ),
                _buildSwitchTile(
                  title: 'Location-based Features',
                  subtitle: 'Use location for nearby offers and local content',
                  value: _settingsService.locationBasedFeatures,
                  onChanged: _updateLocationBasedFeatures,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.orange.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Location data helps provide personalized financial insights and local offers.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange.shade700,
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

  void _updateLocationEnabled(bool value) {
    setState(() => _settingsService.updateLocationSettings(locationEnabled: value));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Location ${value ? 'enabled' : 'disabled'}'), backgroundColor: Colors.green));
  }

  void _updateLocationBasedFeatures(bool value) {
    setState(() => _settingsService.updateLocationSettings(locationBasedFeatures: value));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Location features ${value ? 'enabled' : 'disabled'}'), backgroundColor: Colors.green));
  }
}
