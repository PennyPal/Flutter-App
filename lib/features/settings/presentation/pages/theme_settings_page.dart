import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/services/settings_service.dart';
import '../../../../shared/providers/settings_notifier.dart';

/// Theme settings page
class ThemeSettingsPage extends ConsumerStatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  ConsumerState<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends ConsumerState<ThemeSettingsPage> {
  final _settingsService = SettingsService();

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsNotifierProvider);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;
    final appBarBg = primary;
    final appBarFg = onPrimary;

    // page background should use the in-app scaffold background so dark mode is applied globally
    final pageBg = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: appBarBg,
        foregroundColor: appBarFg,
        title: const Text('Theme Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              context.go(RouteNames.settings);
            }
          },
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
                  groupValue: settings.themeMode,
                  onChanged: (value) => _updateThemeMode(value!),
                ),
                _buildRadioTile(
                  title: 'Dark',
                  subtitle: 'Always use dark theme',
                  value: 'dark',
                  groupValue: settings.themeMode,
                  onChanged: (value) => _updateThemeMode(value!),
                ),
                _buildRadioTile(
                  title: 'System',
                  subtitle: 'Follow system theme',
                  value: 'system',
                  groupValue: settings.themeMode,
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
            const SizedBox(height: 16),
            // Live preview
            _ThemePreview(),
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
  final titleColor = theme.colorScheme.onSurface;

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
              color: titleColor,
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
  final theme = Theme.of(context);
    return RadioListTile<String>(
      title: Text(title, style: TextStyle(color: theme.colorScheme.onSurface)),
  subtitle: Text(subtitle, style: TextStyle(color: theme.colorScheme.onSurface.withAlpha(179))),
      value: value,
      groupValue: groupValue,
      onChanged: (value) => onChanged(value!),
      // activeThumbColor was introduced in newer Flutter versions; keep using
      // activeColor for compatibility (shows deprecation info but compiles).
      activeColor: theme.colorScheme.primary,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildColorOption(String value, String label, Color color) {
    // Use a Builder so we can access `ref` (Riverpod) in this scope
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final settingsLocal = ref.watch(settingsNotifierProvider);
        final isSelected = settingsLocal.accentColor == value;

        return GestureDetector(
          onTap: () => _updateAccentColor(value),
            child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // subtle tint when selected; otherwise use transparent surface
              // use withAlpha instead of withOpacity to avoid precision loss
              color: isSelected ? color.withAlpha((0.08 * 255).round()) : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? theme.colorScheme.primary : Colors.grey.shade300,
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
                    border: Border.all(color: theme.colorScheme.onPrimary, width: 2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Icon(
                    Icons.check,
                    color: theme.brightness == Brightness.dark
                        ? // use a lighter tint for visibility in dark mode
                        HSLColor.fromColor(theme.colorScheme.primary).withLightness((HSLColor.fromColor(theme.colorScheme.primary).lightness + 0.22).clamp(0.0, 1.0)).toColor()
                        : theme.colorScheme.primary,
                    size: 20,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateThemeMode(String mode) {
    // Update both the SettingsService and the Riverpod notifier so app-wide
    // theme reacts immediately.
    _settingsService.updateThemeSettings(themeMode: mode);
    ref.read(settingsNotifierProvider.notifier).updateThemeMode(mode);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Theme mode updated'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _updateAccentColor(String color) {
    _settingsService.updateThemeSettings(accentColor: color);
    ref.read(settingsNotifierProvider.notifier).updateAccentColor(color);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Accent color updated'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class _ThemePreview extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final theme = Theme.of(context);

  // Determine preview background for dark mode; prefer scaffoldBackgroundColor in dark mode
  final isLight = settings.themeMode == 'light' || (settings.themeMode == 'system' && theme.brightness == Brightness.light);
  final previewBg = isLight ? const Color(0xFFFCEFF5) : theme.scaffoldBackgroundColor;

    // Determine accent color
    Color accent;
    switch (settings.accentColor) {
      case 'blue':
        accent = const Color(0xFF3B82F6);
        break;
      case 'green':
        accent = const Color(0xFF10B981);
        break;
      case 'red':
        accent = const Color(0xFFEF4444);
        break;
      case 'orange':
        accent = const Color(0xFFF59E0B);
        break;
      case 'purple':
      default:
        accent = const Color(0xFF6B2C91);
        break;
    }

    Color accentOnText;
    if (['purple', 'blue', 'red'].contains(settings.accentColor)) {
      accentOnText = Colors.white;
    } else {
      accentOnText = Colors.black;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Preview', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: previewBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text('Section title', style: theme.textTheme.bodyLarge?.copyWith(color: isLight ? Colors.black : theme.colorScheme.onSurface)),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: accentOnText,
                  ),
                  child: Text(
                    'Button',
                    // Exception: keep purple preview button label as black per request
                    style: TextStyle(
                      color: settings.accentColor == 'purple' ? Colors.black : accentOnText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
