import 'package:flutter/material.dart';
import '../models/user.dart';
import '../providers/nutrition_provider.dart';
import 'package:provider/provider.dart';

class WaterTracker extends StatelessWidget {
  final User user;

  WaterTracker({required this.user});

  @override
  Widget build(BuildContext context) {
    final nutritionProvider = Provider.of<NutritionProvider>(context);

    return Column(
crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row für Plus/Minus-Buttons und Wassertropfen-Icon
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Wassertropfen-Icon
            Icon(
              Icons.water_drop, // Flutter's eingebautes Wassertropfen-Icon
              size: 64,
              color: Colors.blue,
            ),
            // Plus-Button
            IconButton(
              icon: Icon(Icons.add, size: 30),
              onPressed: () => nutritionProvider.updateWater(0.1),
            ),
            // Minus-Button
            IconButton(
              icon: Icon(Icons.remove, size: 30),
              onPressed: () => nutritionProvider.updateWater(-0.1),
            ),
          ],
        ),
        // Abstand zwischen der Row und dem Balken
        SizedBox(height: 8),
        // Text und Balken
        Text(
          'Wasser ${nutritionProvider.entry.water.toStringAsFixed(1)} / ${user.waterGoal} L',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        LinearProgressIndicator(
          value: nutritionProvider.entry.water / user.waterGoal,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation(Colors.black),
          minHeight: 8, // Etwas dickerer Balken
        ),
      ],
    );
  }
}