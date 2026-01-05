import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../../core/theme/app_theme.dart';
import '../communication/ai_chat_screen.dart';
import '../profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  bool _isDeviceConnected = true;
  int _batteryPercentage = 87;
  Timer? _batteryTimer;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startBatterySimulation();
  }

  void _initAnimations() {
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  void _startBatterySimulation() {
    _batteryTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_batteryPercentage > 20) setState(() => _batteryPercentage--);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _batteryTimer?.cancel();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 18) return 'Afternoon';
    return 'Evening';
  }

  String _getCurrentDateTime() => '${DateTime.now().toLocal().toString().split(' ').first}';

  Color _getBatteryColor() {
    if (_batteryPercentage > 75) return AppColors.success;
    if (_batteryPercentage > 30) return AppColors.warning;
    return AppColors.error;
  }

  void _handleCommunicate() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AIChatScreen()));
  }

  void _handleEmergency() {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.error,
        title: const Row(
          children: [
            Icon(Icons.emergency, color: Colors.white, size: 32),
            SizedBox(width: 12),
            Text('Emergency Mode', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text('Emergency alert has been sent to your caregivers.\n\nHelp is on the way.', style: TextStyle(color: Colors.white, fontSize: 16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.lg),
                child: Column(
                  children: [
                    _buildDeviceCard(),
                    const SizedBox(height: AppDimensions.xl),
                    _buildCommunicateButton(),
                    const SizedBox(height: AppDimensions.lg),
                    _buildEmergencyButton(),
                    const SizedBox(height: AppDimensions.xl),
                    _buildQuickStats(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good ${_getGreeting()}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.neutral900)),
              Text(_getCurrentDateTime(), style: const TextStyle(fontSize: 14, color: AppColors.neutral500)),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen())),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primaryPurple.withOpacity(0.1),
              child: const Icon(Icons.person_outline, color: AppColors.primaryPurple, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.primaryPurple.withOpacity(0.1), AppColors.primaryOrange.withOpacity(0.1)]),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primaryPurple.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusBadge(icon: _isDeviceConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled, label: _isDeviceConnected ? 'Connected' : 'Disconnected', color: _isDeviceConnected ? AppColors.success : AppColors.error),
              _StatusBadge(icon: Icons.battery_charging_full, label: '$_batteryPercentage%', color: _getBatteryColor()),
            ],
          ),
          const SizedBox(height: AppDimensions.lg),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
                  child: const Center(child: Icon(Icons.hearing, size: 72, color: AppColors.primaryPurple)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommunicateButton() {
    return ElevatedButton.icon(
      onPressed: _handleCommunicate,
      icon: const Icon(Icons.chat_bubble_outline),
      label: const Text('Communicate'),
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
    );
  }

  Widget _buildEmergencyButton() {
    return ElevatedButton.icon(
      onPressed: _handleEmergency,
      icon: const Icon(Icons.warning_amber_rounded),
      label: const Text('Emergency'),
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, minimumSize: const Size.fromHeight(48)),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _StatCard(label: 'Sleep', value: '7h 20m'),
        _StatCard(label: 'Focus', value: 'High'),
        _StatCard(label: 'Alerts', value: '2'),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatusBadge({Key? key, required this.icon, required this.label, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: AppDimensions.sm),
        Text(label, style: const TextStyle(color: AppColors.neutral900)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        margin: const EdgeInsets.symmetric(horizontal: AppDimensions.xs),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusMd), border: Border.all(color: AppColors.neutral300)),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: AppColors.neutral500)),
            const SizedBox(height: AppDimensions.sm),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.neutral900)),
          ],
        ),
      ),
    );
  }
}
