import 'package:flutter/material.dart';
import '../models/user.dart';
import '../providers/nutrition_provider.dart';
import 'package:provider/provider.dart';

class MacroTracker extends StatelessWidget {
  final User user;

  const MacroTracker({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final entry = Provider.of<NutritionProvider>(context).entry;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Gleichmäßiger Abstand zwischen den Makros
      children: user.macroGoals.keys.map((macro) {
        // Sichere Zugriffe auf die Werte
        final currentMacro = entry.macros[macro] ?? 0.0;
        final goalMacro = user.macroGoals[macro] ?? 0.0;
        
        // Verhindere Division durch 0
        final progress = goalMacro > 0 ? (currentMacro / goalMacro).clamp(0.0, 1.0) : 0.0;

        return Expanded(
          flex: 1, // Jeder Makro-Balken nimmt 1/3 der Breite ein
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Abstand zwischen den Balken
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$macro ${currentMacro.toInt()} / ${goalMacro.toInt()} g',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10), // Kleiner Abstand zwischen Text und Balken
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation(Colors.black),
                  minHeight: 5, // Etwas dickerer Balken
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
