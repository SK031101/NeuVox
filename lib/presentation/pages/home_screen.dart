import 'package:flutter/material.dart';
import 'package:neuvox/core/constants/app_colors.dart';
import 'package:neuvox/presentation/widgets/gradient_scaffold.dart';
import 'communication/communication_screen.dart';
import 'emergency_screen.dart';
import 'settings_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              
              // Monitor Dashboard
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    children: [
                      // Status Bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.circle, color: AppColors.success, size: 8),
                            const SizedBox(width: 8),
                            const Text("SYSTEM ONLINE", style: TextStyle(color: AppColors.success, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            const Icon(FontAwesomeIcons.bluetooth, color: AppColors.textPrimary, size: 12),
                            const SizedBox(width: 8),
                            const Text("CONNECTED", style: TextStyle(color: AppColors.textPrimary, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Central Data Visualization (Schematic)
                      Column(
                        children: [
                          const Icon(FontAwesomeIcons.glasses, size: 60, color: Colors.white24),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildMetric(label: "SIGNAL", value: "-42 dBm", color: AppColors.primary),
                              const SizedBox(width: 32),
                              _buildMetric(label: "BATTERY", value: "98%", color: AppColors.accent),
                            ],
                          ),
                        ],
                      ).animate().fadeIn(duration: 800.ms),
                      
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Control Panel (Bottom)
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildPanelButton(
                      label: "COMMUNICATE",
                      icon: FontAwesomeIcons.waveSquare,
                      color: AppColors.primary,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CommunicationScreen())),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildPanelButton(
                      label: "SETTINGS",
                      icon: Icons.settings,
                      color: AppColors.backgroundLight,
                      isSecondary: true,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: _buildPanelButton(
                  label: "EMERGENCY ALERT",
                  icon: Icons.warning_amber_rounded,
                  color: AppColors.error,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmergencyScreen())),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('EEEE, MMM d').format(DateTime.now()).toUpperCase(),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        const Text(
          "NeuVox System",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ],
    );
  }

  Widget _buildMetric({required String label, required String value, required Color color}) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, letterSpacing: 1.5)),
      ],
    );
  }

  Widget _buildPanelButton({required String label, required IconData icon, required Color color, required VoidCallback onTap, bool isSecondary = false}) {
    return Material(
      color: isSecondary ? color : color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSecondary ? Colors.white10 : color),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSecondary ? Colors.white : color, size: 24),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(color: isSecondary ? Colors.white : color, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ],
          ),
        ),
      ),
    );
  }
}
