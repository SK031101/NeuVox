import 'package:flutter/material.dart';
import 'package:neuvox/core/constants/app_colors.dart';
import 'package:neuvox/presentation/widgets/gradient_scaffold.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _aiSensitivity = 0.7;
  double _voiceSpeed = 1.0;
  bool _hapticFeedback = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return GradientScaffold(
      appBar: AppBar(
        title: const Text("System Configuration"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Device Section
          _buildSectionHeader("NEURAL INTERFACE"),
          _buildTile(
            icon: Icons.hub,
            title: "Calibration",
            subtitle: "Last calibrated: 2 hours ago",
            onTap: () {}, // TODO: Calibration flow
            trailing: const Text("RECALIBRATE", style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 10)),
          ),
          const SizedBox(height: 10),
          Container(
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(8)),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const Text("AI SENSITIVITY", style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                 Row(
                   children: [
                     const Text("Low", style: TextStyle(color: Colors.white30, fontSize: 10)),
                     Expanded(
                       child: Slider(
                         value: _aiSensitivity,
                         activeColor: AppColors.primary,
                         inactiveColor: Colors.white10,
                         onChanged: (v) => setState(() => _aiSensitivity = v),
                       ),
                     ),
                     const Text("High", style: TextStyle(color: Colors.white30, fontSize: 10)),
                   ],
                 ),
               ],
             ),
          ),
          
          const SizedBox(height: 30),
          
          // Personalization Section (New for V1.0)
          _buildSectionHeader("PERSONALIZATION"),
          _buildTile(
            icon: Icons.mic,
            title: "Voice Studio",
            subtitle: "Create your digital voice clone",
            onTap: () => Navigator.pushNamed(context, '/voice_studio'),
            trailing: const Icon(Icons.chevron_right, color: Colors.white30),
          ),
          _buildTile(
            icon: Icons.school,
            title: "Training Dashboard",
            subtitle: "View accuracy & calibration stats",
            onTap: () => Navigator.pushNamed(context, '/train'),
            trailing: const Icon(Icons.chevron_right, color: Colors.white30),
          ),

          const SizedBox(height: 30),

          // Output Section
          _buildSectionHeader("VOICE OUTPUT"),
           Container(
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(8)),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const Text("SPEAKING RATE", style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                 Row(
                   children: [
                     const Icon(Icons.speed, size: 16, color: Colors.white30),
                     Expanded(
                       child: Slider(
                         value: _voiceSpeed,
                         min: 0.5, max: 2.0,
                         activeColor: AppColors.accent,
                         inactiveColor: Colors.white10,
                         onChanged: (v) => setState(() => _voiceSpeed = v),
                       ),
                     ),
                     Text("${_voiceSpeed.toStringAsFixed(1)}x", style: const TextStyle(color: Colors.white, fontSize: 12)),
                   ],
                 ),
               ],
             ),
          ),
          
          const SizedBox(height: 30),

          // Account Section
          _buildSectionHeader("ACCOUNT"),
          _buildTile(
            icon: Icons.person,
            title: "Profile info",
            subtitle: "John Doe (Patient ID: 8821)",
            onTap: () {},
          ),
          const SizedBox(height: 20),
          
          // Logout
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
               style: OutlinedButton.styleFrom(
                 side: BorderSide(color: Colors.red.withOpacity(0.5)),
                 padding: const EdgeInsets.symmetric(vertical: 16),
               ),
               onPressed: () {
                 authProvider.logout();
                 Navigator.of(context).popUntil((route) => route.isFirst);
               },
               child: const Text("DISCONNECT FROM AZURE AD", style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildTile({required IconData icon, required String title, required String subtitle, VoidCallback? onTap, Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
