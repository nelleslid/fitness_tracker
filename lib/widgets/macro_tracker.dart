import 'package:flutter/material.dart';
import '../models/user.dart';
import '../providers/nutrition_provider.dart';
import 'package:provider/provider.dart';

class MacroTracker extends StatelessWidget {
  final User user;

  MacroTracker({required this.user});

  @override
  Widget build(BuildContext context) {
    final entry = Provider.of<NutritionProvider>(context).entry;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Gleichmäßiger Abstand zwischen den Makros
      children: user.macroGoals.keys.map((macro) {
        return Expanded(
          flex: 1, // Jeder Makro-Balken nimmt 1/3 der Breite ein
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Abstand zwischen den Balken
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$macro ${entry.macros[macro]!.toInt()} / ${user.macroGoals[macro]!.toInt()} g',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 10), // Kleiner Abstand zwischen Text und Balken
                LinearProgressIndicator(
                  value: entry.macros[macro]! / user.macroGoals[macro]!,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation(Colors.black),
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
