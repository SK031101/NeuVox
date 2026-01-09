import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  String _status = "Acquiring GPS Satellites...";
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _startEmergencyProtocol();
  }

  Future<void> _startEmergencyProtocol() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _status = "Locking Location (47.64, -122.13)...");
    
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _status = "Broadcasting to First Responders...");
    
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _status = "ALERT SENT. HELP IS ON THE WAY.";
      _sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Pulse
            Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _sent ? Colors.green.withOpacity(0.2) : AppColors.error.withOpacity(0.2),
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(1, 1), end: const Offset(1.5, 1.5), duration: 1.seconds),
            ),
            
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // Icon
                Icon(
                  _sent ? Icons.check_circle : Icons.warning_amber_rounded,
                  size: 100,
                  color: _sent ? Colors.green : AppColors.error,
                ).animate().shake(duration: 500.ms, hz: 4).scale(duration: 500.ms),
                
                const SizedBox(height: 32),
                
                // Text
                Text(
                  _sent ? "AID CONFIRMED" : "EMERGENCY SOS",
                  style: TextStyle(
                    color: _sent ? Colors.green : AppColors.error,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                
                const Spacer(),
                
                // Cancel Button
                if (!_sent)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.close),
                          SizedBox(width: 8),
                          Text("CANCEL ALERT"),
                        ],
                      ),
                    ),
                  ),
                  
                if (_sent)
                   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                      child: const Text("CLOSE"),
                    ),
                  ),
                
                const SizedBox(height: 48),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
