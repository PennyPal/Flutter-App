import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
// theme imports removed: using Theme.of(context) instead
import '../../../../shared/services/user_service.dart';
import '../../../../shared/services/profile_picture_service.dart';
import '../widgets/profile_picture_selection_dialog.dart';

/// Edit profile page for updating user information
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _userService = UserService();
  final _profilePictureService = ProfilePictureService();
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for form fields
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _ageController;
  late TextEditingController _emailController;
  late TextEditingController _descriptionController;
  late TextEditingController _interestsController;
  
  // Password change controllers
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  
  // Profile data (temporary changes that aren't saved yet)
  String _tempProfilePicture = '';
  String _tempProfilePictureType = '';
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  String _fromParam = '';

  void _initializeControllers() {
    _nameController = TextEditingController(text: _userService.userName);
    _usernameController = TextEditingController(text: _userService.username);
    _ageController = TextEditingController(text: _userService.age.toString());
    _emailController = TextEditingController(text: _userService.userEmail);
    _descriptionController = TextEditingController(text: _userService.profileDescription);
    _interestsController = TextEditingController(text: _userService.interests);
    
    // Initialize password controllers
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    
    // Initialize temporary profile picture data
    _tempProfilePicture = _userService.profilePicture;
    _tempProfilePictureType = _userService.profilePictureType;
    
    // Add listeners to detect changes
    _nameController.addListener(_onFieldChanged);
    _usernameController.addListener(_onFieldChanged);
    _ageController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
    _interestsController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFieldChanged);
    _usernameController.removeListener(_onFieldChanged);
    _ageController.removeListener(_onFieldChanged);
    _emailController.removeListener(_onFieldChanged);
    _descriptionController.removeListener(_onFieldChanged);
    _interestsController.removeListener(_onFieldChanged);
    
    _nameController.dispose();
    _usernameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _interestsController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  bool _hasFormChanges() {
    return _nameController.text.trim() != _userService.userName ||
           _usernameController.text.trim() != _userService.username ||
           _ageController.text.trim() != _userService.age.toString() ||
           _emailController.text.trim() != _userService.userEmail ||
           _descriptionController.text.trim() != _userService.profileDescription ||
           _interestsController.text.trim() != _userService.interests ||
           _tempProfilePicture != _userService.profilePicture ||
           _tempProfilePictureType != _userService.profilePictureType;
  }

  @override
  Widget build(BuildContext context) {
    // Read optional query param 'from' to determine where to go back to
  // On web and other platforms, read the query parameter from the current URI
  _fromParam = Uri.base.queryParameters['from'] ?? '';
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _handleBackNavigation(),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            style: TextButton.styleFrom(foregroundColor: theme.colorScheme.onPrimary),
            child: const Text(
              'Save',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
                _buildProfilePictureSection(),
              
              const SizedBox(height: 24),
              
              // Name Field
              _buildTextField(
                controller: _nameController,
                label: 'Name',
                icon: Icons.person,
                validator: (value) => value?.isEmpty == true ? 'Name is required' : null,
              ),
              
              const SizedBox(height: 16),
              
              // Username Field
              _buildTextField(
                controller: _usernameController,
                label: 'Username',
                icon: Icons.alternate_email,
                validator: (value) => value?.isEmpty == true ? 'Username is required' : null,
              ),
              
              const SizedBox(height: 16),
              
              // Age Field
              _buildTextField(
                controller: _ageController,
                label: 'Age',
                icon: Icons.cake,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Age is required';
                  final age = int.tryParse(value!);
                  if (age == null || age < 13 || age > 120) {
                    return 'Please enter a valid age (13-120)';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Email Field
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Email is required';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Profile Description Field
              _buildTextField(
                controller: _descriptionController,
                label: 'Profile Description',
                icon: Icons.description,
                maxLines: 3,
                validator: (value) => value?.isEmpty == true ? 'Description is required' : null,
              ),
              
              const SizedBox(height: 16),
              
              // Interests Field
              _buildTextField(
                controller: _interestsController,
                label: 'Interests (comma separated)',
                icon: Icons.favorite,
                validator: (value) => value?.isEmpty == true ? 'Interests are required' : null,
              ),
              
              const SizedBox(height: 24),
              
              // Password Change Section
              _buildPasswordChangeSection(),
              
              const SizedBox(height: 32),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}) ?? theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Center(
      child: Column(
        children: [
          // Profile Picture
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).colorScheme.onSurface.withAlpha((0.08 * 255).round()), width: 2),
            ),
          child: Center(
            child: _profilePictureService.getProfilePictureWidget(
              type: _tempProfilePictureType,
              value: _tempProfilePicture,
              size: 60,
            ),
          ),
          ),
          
          const SizedBox(height: 12),
          
          // Change Picture Button
          TextButton.icon(
            onPressed: _changeProfilePicture,
            icon: Icon(Icons.camera_alt, color: Theme.of(context).colorScheme.primary),
            label: Text(
              'Change Picture',
              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);

    return Container(
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
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: theme.colorScheme.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceVariant ?? theme.colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  void _changeProfilePicture() {
    showDialog(
      context: context,
      builder: (context) => ProfilePictureSelectionDialog(
        onPictureSelected: (pictureValue, pictureType) {
          setState(() {
            _tempProfilePicture = pictureValue;
            _tempProfilePictureType = pictureType;
            _hasUnsavedChanges = true;
          });
        },
      ),
    );
  }

  void _handleBackNavigation() {
    if (_hasFormChanges()) {
      _showUnsavedChangesDialog();
    } else {
      // Prefer popping the navigation stack when possible so the originating
      // route (profile or settings) is restored. If we can't pop (e.g. deep
      // link), fall back to route by query param.
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
        return;
      }

      if (_fromParam == 'dashboard') {
        context.go(RouteNames.home);
      } else if (_fromParam == 'profile') {
        context.go(RouteNames.profile);
      } else if (_fromParam == 'settings') {
        context.go(RouteNames.settings);
      } else {
        context.go(RouteNames.profile);
      }
    }
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('You have unsaved changes. Do you want to save them before leaving?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                context.go(RouteNames.profile);
              }
            },
            child: const Text('Discard'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _saveProfile();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordChangeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
  border: Border.all(color: Theme.of(context).colorScheme.primary.withAlpha((0.2 * 255).round())),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lock_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Change Password',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Current Password
          _buildPasswordField(
            controller: _currentPasswordController,
            label: 'Current Password',
            icon: Icons.lock,
          ),
          
          const SizedBox(height: 12),
          
          // New Password
          _buildPasswordField(
            controller: _newPasswordController,
            label: 'New Password',
            icon: Icons.lock_outline,
          ),
          
          const SizedBox(height: 12),
          
          // Confirm Password
          _buildPasswordField(
            controller: _confirmPasswordController,
            label: 'Confirm New Password',
            icon: Icons.lock_outline,
          ),
          
          const SizedBox(height: 16),
          
          // Change Password Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Change Password',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: theme.colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant ?? theme.colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  void _changePassword() {
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all password fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New password must be at least 6 characters long'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // In a real app, you would validate the current password and update it in the database
    // For now, we'll just show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password changed successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Clear password fields
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() == true) {
      _userService.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        username: _usernameController.text.trim(),
        age: int.tryParse(_ageController.text.trim()),
        description: _descriptionController.text.trim(),
        interests: _interestsController.text.trim(),
        profilePicture: _tempProfilePicture,
        profilePictureType: _tempProfilePictureType,
      );
      
      // Reset unsaved changes flag
      setState(() {
        _hasUnsavedChanges = false;
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate back to profile page (prefer popping if possible to restore origin)
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        context.go(RouteNames.profile);
      }
    }
  }
}
