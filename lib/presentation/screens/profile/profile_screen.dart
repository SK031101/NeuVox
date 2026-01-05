import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: AppDimensions.lg),
              
              _buildProfileHeader(),
              
              const SizedBox(height: AppDimensions.xl),
              
              _buildSection(
                context,
                'Account',
                [
                  _buildSettingTile(
                    context,
                    Icons.person_outline,
                    'Personal Information',
                    'Update your profile details',
                    () => _showComingSoon(context),
                  ),
                  _buildSettingTile(
                    context,
                    Icons.credit_card_outlined,
                    'Subscription & Plan',
                    'Manage your subscription',
                    () => _showSubscriptionDialog(context),
                  ),
                ],
              ),
              
              _buildSection(
                context,
                'Device',
                [
                  _buildSettingTile(
                    context,
                    Icons.bluetooth_outlined,
                    'Device Settings',
                    'Configure smart glasses',
                    () => _showComingSoon(context),
                  ),
                  _buildSettingTile(
                    context,
                    Icons.mic_outlined,
                    'Voice Profile',
                    'Train your voice model',
                    () => _showComingSoon(context),
                  ),
                ],
              ),
              
              _buildSection(
                context,
                'Support',
                [
                  _buildSettingTile(
                    context,
                    Icons.chat_bubble_outline,
                    'Support Chat',
                    'Get help from our team',
                    () => _showComingSoon(context),
                  ),
                  _buildSettingTile(
                    context,
                    Icons.info_outline,
                    'About NeuVox',
                    'Version 1.0.0',
                    () => _showAboutDialog(context),
                  ),
                ],
              ),
              
              _buildSection(
                context,
                'Privacy & AI',
                [
                  _buildSettingTile(
                    context,
                    Icons.privacy_tip_outlined,
                    'Privacy Policy',
                    'How we protect your data',
                    () => _showComingSoon(context),
                  ),
                  _buildSettingTile(
                    context,
                    Icons.psychology_outlined,
                    'Responsible AI',
                    'Our AI ethics commitment',
                    () => _showResponsibleAI(context),
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.xl),
              
              Padding(
                padding: const EdgeInsets.all(AppDimensions.lg),
                child: SizedBox(
                  width: double.infinity,
                  height: AppDimensions.minTapTarget,
                  child: OutlinedButton(
                    onPressed: () => _handleLogout(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppDimensions.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primaryPurple.withOpacity(0.1),
          child: const Icon(
            Icons.person,
            size: 50,
            color: AppColors.primaryPurple,
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        const Text(
          'John Doe',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.neutral900,
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        const Text(
          'john.doe@microsoft.com',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.neutral500,
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: AppDimensions.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          child: const Text(
            'Premium Plan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryOrange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> tiles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
            vertical: AppDimensions.sm,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral500,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: AppColors.neutral300.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Column(children: tiles),
        ),
        const SizedBox(height: AppDimensions.lg),
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primaryPurple, size: 22),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.neutral500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.neutral300,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showSubscriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Subscription'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Plan: Premium'),
            SizedBox(height: 8),
            Text(
              'Features:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.neutral900,
              ),
            ),
            Text('• Unlimited messages'),
            Text('• Priority support'),
            Text('• Advanced AI models'),
            Text('• Multi-device sync'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About NeuVox'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NeuVox',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text(
              'Restoring Speech. Restoring Identity.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16),
            Text(
              'Developed for Microsoft Imagine Cup 2025\n\n'
              '© 2025 NeuVox. All rights reserved.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showResponsibleAI(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Responsible AI'),
        content: const SingleChildScrollView(
          child: Text(
            'Our Commitment:\n\n'
            '1. Transparency\n'
            'We clearly explain how our AI interprets neural signals.\n\n'
            '2. Privacy\n'
            'Your neural data is encrypted and never shared without consent.\n\n'
            '3. Accuracy\n'
            'Our models are continuously trained to improve interpretation accuracy.\n\n'
            '4. Fairness\n'
            'We work to eliminate bias in our AI systems.\n\n'
            '5. Safety\n'
            'User safety is our top priority in all AI interactions.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
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
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}