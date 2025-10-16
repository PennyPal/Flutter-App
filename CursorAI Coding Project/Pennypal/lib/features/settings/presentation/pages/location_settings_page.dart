import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/services/settings_service.dart';
import '../../../../core/router/route_names.dart';
import 'package:permission_handler/permission_handler.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const Text('Location Settings'),
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
                color: theme.colorScheme.primary.withAlpha((0.08 * 255).round()),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.primary.withAlpha((0.2 * 255).round())),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: theme.colorScheme.primary.withAlpha((0.8 * 255).round()),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Location data helps provide personalized financial insights and local offers.',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.primary.withAlpha((0.8 * 255).round()),
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
  boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.05 * 255).round()), blurRadius: 8, offset: const Offset(0, 2))],
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
    if (value) {
      Permission.location.request().then((status) {
        final granted = status.isGranted;
        setState(() => _settingsService.updateLocationSettings(locationEnabled: granted));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Location ${granted ? 'enabled' : 'denied by user'}'), backgroundColor: granted ? Colors.green : Colors.red));
      });
    } else {
      setState(() => _settingsService.updateLocationSettings(locationEnabled: false));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Location disabled'), backgroundColor: Colors.green));
    }
  }

  void _updateLocationBasedFeatures(bool value) {
    setState(() => _settingsService.updateLocationSettings(locationBasedFeatures: value));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Location features ${value ? 'enabled' : 'disabled'}'), backgroundColor: Colors.green));
  }
}
