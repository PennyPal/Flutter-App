import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/services/auth_service.dart';
import 'otp_verification_page.dart';

/// OTP Login page for phone and email authentication
class OTPLoginPage extends StatefulWidget {
  const OTPLoginPage({super.key});

  @override
  State<OTPLoginPage> createState() => _OTPLoginPageState();
}

class _OTPLoginPageState extends State<OTPLoginPage>
    with SingleTickerProviderStateMixin {
  final _authService = AuthService();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  late TabController _tabController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _sendPhoneOTP() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      _showError('Please enter your phone number');
      return;
    }

    // Basic phone validation
    if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phone)) {
      _showError('Please enter a valid phone number with country code (e.g., +1234567890)');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = await _authService.createPhoneToken(phone: phone);

      if (mounted) {
        // Navigate to OTP verification page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OTPVerificationPage(
              userId: token.userId,
              contactInfo: phone,
              verificationType: 'phone',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _sendEmailOTP() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showError('Please enter your email');
      return;
    }

    // Basic email validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showError('Please enter a valid email address');
      return;
    }

    setState(() => _isLoading = false);

    try {
      final token = await _authService.createEmailToken(email: email);

      if (mounted) {
        // Navigate to OTP verification page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OTPVerificationPage(
              userId: token.userId,
              contactInfo: email,
              verificationType: 'email',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.xl),
              child: Column(
                children: [
                  // Logo/Icon
                  Container(
                    padding: const EdgeInsets.all(AppTheme.lg),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: AppTheme.xl),

                  // Title
                  Text(
                    'Passwordless Login',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),

                  const SizedBox(height: AppTheme.sm),

                  // Subtitle
                  Text(
                    'Login with OTP sent to your phone or email',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppTheme.xl),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade600,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.phone_android),
                    text: 'Phone',
                  ),
                  Tab(
                    icon: Icon(Icons.email_outlined),
                    text: 'Email',
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.xl),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPhoneTab(),
                  _buildEmailTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Phone Input
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: '+1234567890',
              prefixIcon: const Icon(Icons.phone),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),

          const SizedBox(height: AppTheme.md),

          // Info Text
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: AppTheme.xs),
              Expanded(
                child: Text(
                  'Include country code (e.g., +1 for US)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.xxl),

          // Send OTP Button
          ElevatedButton(
            onPressed: _isLoading ? null : _sendPhoneOTP,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: AppTheme.lg),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Send OTP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Input
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'your@email.com',
              prefixIcon: const Icon(Icons.email_outlined),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),

          const SizedBox(height: AppTheme.md),

          // Info Text
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: AppTheme.xs),
              Expanded(
                child: Text(
                  'We\'ll send a 6-digit code to your email',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.xxl),

          // Send OTP Button
          ElevatedButton(
            onPressed: _isLoading ? null : _sendEmailOTP,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: AppTheme.lg),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Send OTP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

