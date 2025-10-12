import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8E8EB), // Light pink background
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
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => context.go(RouteNames.home),
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              padding: EdgeInsets.zero,
            ),
          ),
          
          // Settings icon
          IconButton(
            onPressed: () => context.go(RouteNames.settings),
            icon: const Icon(Icons.settings, color: Colors.black),
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
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 1),
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
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        
        const SizedBox(height: 4),
        
        // Username
        Text(
          _username,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Edit Profile button
            GestureDetector(
              onTap: () => context.go(RouteNames.profileEdit),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
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
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFFC74B50), // Dark red/magenta color
        ),
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