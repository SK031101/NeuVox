import 'package:flutter/material.dart';
import 'package:neuvox/core/constants/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  bool _isActive = false;
  int _countdown = 5;

  void _activateEmergency() async {
    setState(() => _isActive = true);
    
    // Countdown simulation
    for (int i = 5; i > 0; i--) {
       if (!mounted || !_isActive) return; // Cancelled
       setState(() => _countdown = i);
       await Future.delayed(const Duration(seconds: 1));
    }
    
    if (!mounted || !_isActive) return;

    // Trigger Action (Mock)
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
         content: Text("ALERTS SENT! Location Shared with Emergency Contacts."), 
         backgroundColor: Colors.red,
         duration: Duration(seconds: 5),
      ),
    );
    
    // Attempt call (Mock)
    final Uri launchUri = Uri(scheme: 'tel', path: '911');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _cancel() {
    setState(() {
      _isActive = false;
      _countdown = 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Maximum contrast
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isActive) ...[
               const Icon(Icons.warning_amber_rounded, size: 80, color: AppColors.error),
               const SizedBox(height: 20),
               const Text(
                 "EMERGENCY MODE",
                 style: TextStyle(color: AppColors.error, fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 2),
               ),
               const SizedBox(height: 60),
               GestureDetector(
                 onLongPress: _activateEmergency, // Prevent accidental taps? Or requirement says "One-tap"? Req says "One-tap activation"
                 onTap: _activateEmergency,
                 child: Container(
                   width: 200,
                   height: 200,
                   decoration: BoxDecoration(
                     color: AppColors.error,
                     shape: BoxShape.circle,
                     boxShadow: [
                       BoxShadow(color: AppColors.error.withOpacity(0.4), blurRadius: 40, spreadRadius: 10),
                     ],
                   ),
                   child: const Center(
                     child: Text("TAP FOR\nHELP", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                   ),
                 ).animate(onPlay: (c) => c.repeat(reverse: true)) // Pulse effect
                  .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 800.ms),
               const SizedBox(height: 40),
               const Text("Notifies Emergency Contacts\n& Shares Location", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54)),
            ] else ...[
               Text("SENDING ALERT IN", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 20)),
               const SizedBox(height: 20),
               Text("$_countdown", style: const TextStyle(color: AppColors.error, fontSize: 100, fontWeight: FontWeight.bold))
                   .animate(key: ValueKey(_countdown)).scale(curve: Curves.elasticOut, duration: 500.ms),
               const SizedBox(height: 60),
               ElevatedButton(
                 onPressed: _cancel,
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.white,
                   foregroundColor: Colors.black,
                   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                 ),
                 child: const Text("CANCEL", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
               ),
            ],
          ],
        ),
      ),
    );
  }
}

