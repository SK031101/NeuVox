import 'package:flutter/material.dart';
import 'package:neuvox/core/constants/app_colors.dart';
import 'package:neuvox/presentation/widgets/gradient_scaffold.dart';

class TrainScreen extends StatelessWidget {
  const TrainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Training & Calibration",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                _buildTrainingCard(
                  title: "Imagine 'Move Left'",
                  progress: 0.8,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                _buildTrainingCard(
                  title: "Imagine 'Move Right'",
                  progress: 0.6,
                  color: Colors.purple,
                ),
                const SizedBox(height: 16),
                _buildTrainingCard(
                  title: "Imagine 'Select'",
                  progress: 0.9,
                  color: Colors.green,
                ),
                
                const SizedBox(height: 32),
                
                const Text(
                  "Calibration History",
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white70
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                       ListTile(
                         leading: const Icon(Icons.check_circle, color: Colors.green),
                         title: const Text("Session #104", style: TextStyle(color: Colors.white)),
                         subtitle: const Text("Accuracy: 98% • 2 hours ago", style: TextStyle(color: Colors.white54)),
                         tileColor: Colors.white10,
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                       ),
                       const SizedBox(height: 8),
                       ListTile(
                         leading: const Icon(Icons.check_circle, color: Colors.green),
                         title: const Text("Session #103", style: TextStyle(color: Colors.white)),
                         subtitle: const Text("Accuracy: 94% • Yesterday", style: TextStyle(color: Colors.white54)),
                         tileColor: Colors.white10,
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                       ),
                    ],
                  ),
                ),
             ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrainingCard({required String title, required double progress, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Text("${(progress * 100).toInt()}%", style: TextStyle(color: color)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white10,
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
