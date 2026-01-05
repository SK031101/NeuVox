import 'package:flutter/material.dart';
import 'package:neuvox/core/constants/app_colors.dart';
import 'package:neuvox/presentation/widgets/gradient_scaffold.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          _buildSectionHeader("Profile"),
          _buildListTile(
            icon: Icons.person,
            title: "John Doe",
            subtitle: "NeuVox Pro User",
            trailing: const Icon(Icons.edit, color: AppColors.textSecondary, size: 20),
          ),
          _buildListTile(
            icon: Icons.credit_card,
            title: "Subscription",
            subtitle: "Active (Renews Jan 2026)",
            trailing: const Text("Manage", style: TextStyle(color: AppColors.primary)),
          ),

          const SizedBox(height: 24),
          
          // Device Section
          _buildSectionHeader("Device"),
          _buildListTile(
            icon: Icons.remove_red_eye,
            title: "NeuVox Glasses V2",
            subtitle: "Connected • Battery 98%",
            trailing: const Icon(Icons.check_circle, color: AppColors.success, size: 20),
          ),
          _buildListTile(
            icon: Icons.tune,
            title: "Calibration",
            subtitle: "Last calibrated: 2 days ago",
            onTap: () {
               showDialog(
                 context: context, 
                 builder: (_) => AlertDialog(
                   backgroundColor: AppColors.backgroundLight,
                   title: const Text("Calibrate Sensors", style: TextStyle(color: Colors.white)),
                   content: const Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Text("Look at the center dot...", style: TextStyle(color: Colors.white70)),
                       SizedBox(height: 20),
                       CircularProgressIndicator(color: AppColors.primary),
                     ],
                   ),
                   actions: [
                     TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                   ],
                 ),
               );
            },
          ),
          
          const SizedBox(height: 24),

          // Support
           _buildSectionHeader("Support"),
          _buildListTile(icon: Icons.help_outline, title: "Help & FAQs", subtitle: null),
          _buildListTile(icon: Icons.info_outline, title: "About NeuVox", subtitle: "Version 1.0.0"),
          
          const SizedBox(height: 40),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false); // Logout mock
            }, 
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
              foregroundColor: AppColors.error,
              padding: const EdgeInsets.all(16),
            ),
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)) : null,
        trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      ),
    ).animate().fadeIn().slideX(begin: -0.1, duration: 400.ms);
  }
}
