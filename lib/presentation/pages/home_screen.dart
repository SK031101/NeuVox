import 'package:flutter/material.dart';
import 'package:neuvox/core/constants/app_colors.dart';
import 'package:neuvox/presentation/widgets/gradient_scaffold.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'communication_screen.dart';
import 'emergency_screen.dart'; // Stub
import 'settings_screen.dart'; // Stub

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateString = DateFormat('EEEE, d MMMM').format(now);
    final timeString = DateFormat('h:mm a').format(now);

    return GradientScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
             const SizedBox(height: 20),
             // Top Bar: Date & Time + Status
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(dateString.toUpperCase(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, letterSpacing: 1)),
                     Text(timeString, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                   ],
                 ),
                 Row(
                   children: [
                     _buildStatusBadge(icon: Icons.battery_full, label: "98%", color: AppColors.success),
                     const SizedBox(width: 8),
                     _buildStatusBadge(icon: Icons.bluetooth_connected, label: "Connected", color: AppColors.primary),
                   ],
                 )
               ],
             ),
             
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                   // Pulse Animation (Behind)
                   Container(
                     width: 300,
                     height: 300,
                     decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       color: AppColors.primary.withOpacity(0.1),
                     ),
                   ).animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 2.seconds)
                    .fade(begin: 0.2, end: 0.5),

                    // 3D Model Placeholder (Using mock image or icon for now)
                    Image.asset(
                      'assets/images/glasses_mock.png',
                      width: 280,
                      errorBuilder: (c,e,s) => Icon(Icons.abc, size: 200, color: Colors.white.withOpacity(0.5)), // Fallback
                    ).animate(onPlay: (c) => c.repeat(reverse: true))
                     .moveY(begin: -10, end: 10, duration: 3.seconds, curve: Curves.easeInOut), // Floating effect
                ],
              ),
            ),
             
            // Bottom Actions
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                   Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CommunicationScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.record_voice_over, size: 28),
                    SizedBox(width: 12),
                    Text("START COMMUNICATION", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ],
                ),
              ),
            ).animate().slideY(begin: 1, duration: 600.ms, curve: Curves.easeOutBack),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildSecondaryButton(
                    context,
                    label: "Emergency",
                    icon: Icons.warning_amber_rounded,
                    color: AppColors.error,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmergencyScreen())),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSecondaryButton(
                    context,
                    label: "Settings",
                    icon: Icons.settings,
                    color: AppColors.backgroundLight,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
                  ),
                ),
              ],
            ).animate().slideY(begin: 1, duration: 800.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, {required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
     return InkWell(
       onTap: onTap,
       borderRadius: BorderRadius.circular(16),
       child: Container(
         padding: const EdgeInsets.symmetric(vertical: 16),
         decoration: BoxDecoration(
           color: color == AppColors.backgroundLight ? Colors.white.withOpacity(0.1) : color.withOpacity(0.2),
           borderRadius: BorderRadius.circular(16),
           border: Border.all(color: color == AppColors.backgroundLight ? Colors.white.withOpacity(0.2) : color),
         ),
         child: Column(
           children: [
             Icon(icon, color: color == AppColors.backgroundLight ? Colors.white : color, size: 24),
             const SizedBox(height: 8),
             Text(label, style: TextStyle(color: color == AppColors.backgroundLight ? Colors.white : color, fontWeight: FontWeight.w600)),
           ],
         ),
       ),
     );
  }
}
