import 'package:flutter/material.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/services/user_service.dart';

/// Enhanced profile page with user information
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Get data from UserService
  final _userService = UserService();
  
  // Local stats (would come from transaction/budget services in real app)
  int _memberSince = 2024;
  int _totalTransactions = 142;
  double _totalSaved = 1250.75;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with gradient
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Profile Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppTheme.md),
                      // User Name
                      Text(
                        _userService.userName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Member since $_memberSince',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => _showEditProfileDialog(),
                icon: const Icon(Icons.edit, color: Colors.white),
              ),
            ],
          ),
          
          // Profile Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Cards
                  _buildStatsSection(),
                  const SizedBox(height: AppTheme.xl),
                  
                  // Profile Information
                  _buildProfileInfo(),
                  const SizedBox(height: AppTheme.xl),
                  
                  // Settings & Actions
                  _buildActionsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Financial Journey',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: AppTheme.lg),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Transactions',
                _totalTransactions.toString(),
                Icons.receipt_long,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: AppTheme.md),
            Expanded(
              child: _buildStatCard(
                'Total Saved',
                '\$${_totalSaved.toStringAsFixed(2)}',
                Icons.savings,
                AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.md),
        Row(
          children: [
            Expanded(
              child:               _buildStatCard(
                'Monthly Income',
                '\$${_userService.monthlyIncome.toStringAsFixed(0)}',
                Icons.trending_up,
                AppColors.info,
              ),
            ),
            const SizedBox(width: AppTheme.md),
            Expanded(
              child: _buildStatCard(
                'Savings Rate',
                '${_userService.monthlyIncome > 0 ? ((_totalSaved / _userService.monthlyIncome) * 100).toStringAsFixed(1) : '0.0'}%',
                Icons.pie_chart,
                AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg.x),
        border: Border.all(color: AppColors.onSurface.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
            ],
          ),
          const SizedBox(height: AppTheme.sm),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onBackground,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg.x),
        border: Border.all(color: AppColors.onSurface.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: AppTheme.lg),
          _buildInfoRow('Name', _userService.userName, Icons.person),
          _buildInfoRow('Email', _userService.userEmail, Icons.email),
          _buildInfoRow('Monthly Income', '\$${_userService.monthlyIncome.toStringAsFixed(2)}', Icons.attach_money),
          _buildInfoRow('Joined', 'January $_memberSince', Icons.calendar_today),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.md),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: AppTheme.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onBackground,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg.x),
        border: Border.all(color: AppColors.onSurface.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings & Actions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: AppTheme.lg),
          _buildActionTile('Edit Profile', Icons.edit, () => _showEditProfileDialog()),
          _buildActionTile('Export Data', Icons.download, () => _exportData()),
          _buildActionTile('Notifications', Icons.notifications, () => _showNotificationSettings()),
          _buildActionTile('Privacy & Security', Icons.security, () => _showPrivacySettings()),
          _buildActionTile('Help & Support', Icons.help, () => _showHelpSupport()),
          _buildActionTile('Sign Out', Icons.logout, () => _signOut(), isDestructive: true),
        ],
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.primary,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: isDestructive ? AppColors.error : AppColors.onBackground,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userService.userName);
    final emailController = TextEditingController(text: _userService.userEmail);
    final incomeController = TextEditingController(text: _userService.monthlyIncome.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppTheme.md),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppTheme.md),
              TextField(
                controller: incomeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly Income',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Update user service
              _userService.updateProfile(
                name: nameController.text.trim(),
                email: emailController.text.trim(),
                income: double.tryParse(incomeController.text) ?? _userService.monthlyIncome,
              );
              
              setState(() {}); // Refresh UI
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data export feature coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showNotificationSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification settings coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showPrivacySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy settings coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showHelpSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Help & support coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Signed out successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
              // In real app, navigate to login screen
            },
            child: const Text('Sign Out'),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
          ),
        ],
      ),
    );
  }
}
