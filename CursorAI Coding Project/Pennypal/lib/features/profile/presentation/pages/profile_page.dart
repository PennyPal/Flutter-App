import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
// removed unused theme imports; this page uses Theme.of(context) directly
import '../../../../shared/services/user_service.dart';
import '../../../../shared/services/gamification_service.dart';
import '../../../../shared/services/profile_picture_service.dart';

/// Profile page matching the provided design
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _userService = UserService();
  final _gamificationService = GamificationService();
  final _profilePictureService = ProfilePictureService();
  
  // Expose the current theme so helper methods can reference it without
  // needing to call Theme.of(context) repeatedly or pass it around.
  ThemeData get theme => Theme.of(context);
  
  // Username derived from user service
  String get _username => _userService.username;

  @override
  void initState() {
    super.initState();
    // Initialize with sample data for demo
    _gamificationService.initializeWithSampleData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            _buildHeader(),
            
            // Profile picture and user info
            _buildProfileSection(),
            
            // Dashboard section
            _buildDashboardSection(),
            
            const Spacer(),
            
            // Reset User Data button
            _buildResetButton(),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => context.go(RouteNames.home),
              icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
              padding: EdgeInsets.zero,
            ),
          ),
          
          // Settings icon
          IconButton(
            onPressed: () => context.go(RouteNames.settings),
            icon: Icon(Icons.settings, color: theme.colorScheme.onSurface),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        // Profile picture
        Container(
          width: 120,
          height: 120,
    decoration: BoxDecoration(
      color: theme.colorScheme.surface,
      shape: BoxShape.circle,
  border: Border.all(color: theme.colorScheme.onSurface.withAlpha((0.08 * 255).round()), width: 1),
    ),
          child: Center(
            child: _profilePictureService.getProfilePictureWidget(
              type: _userService.profilePictureType,
              value: _userService.profilePicture,
              size: 60,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // User name
        Text(
          _userService.userName,
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
        ),
        
        const SizedBox(height: 4),
        
        // Username
        Text(
          _username,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round())),
        ),
        
        const SizedBox(height: 20),
        
  // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Edit Profile button
            GestureDetector(
              onTap: () => context.push('${RouteNames.profileEdit}?from=profile'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.colorScheme.onSurface, width: 1),
                ),
                child: Text(
                  'Edit Profile',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildDashboardSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withAlpha((0.06 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dashboard title
          Text(
            'DASHBOARD:',
            style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round()), fontWeight: FontWeight.w500),
          ),
          
          const SizedBox(height: 16),
          
          // Stats
          _buildStatItem('Level Status: Level ${_gamificationService.currentLevel}'),
          _buildStatItem('Active Days: ${_gamificationService.activeDays} Days'),
          _buildStatItem('Quizzes: ${_gamificationService.quizzesCompleted}'),
          _buildStatItem('Badges Earned: ${_gamificationService.badgesEarned}'),
          
          const SizedBox(height: 16),
          
          // Badges
          Row(
            children: List.generate(_gamificationService.badgesEarned, (index) => 
              Container(
                margin: const EdgeInsets.only(right: 8),
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD700), // Gold color
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildResetButton() {
    return GestureDetector(
      onTap: _showResetConfirmation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF44336), // Red background
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Reset User Data',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset User Data'),
        content: const Text('Are you sure you want to reset all your progress? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetUserData();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _resetUserData() {
    _gamificationService.resetData();
    _userService.clearUserData();
    setState(() {});
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User data has been reset'),
        backgroundColor: Colors.green,
      ),
    );
  }
}