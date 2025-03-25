import 'package:flutter/material.dart';
import 'calorie_circle_painter.dart';
import '../models/user.dart';
import '../providers/nutrition_provider.dart';
import 'package:provider/provider.dart';

class CalorieTracker extends StatelessWidget {
  final User user;

  CalorieTracker({required this.user});

  @override
  Widget build(BuildContext context) {
    final entry = Provider.of<NutritionProvider>(context).entry;

    // Beispiel: Bonus-Kalorien aus Sport (später dynamisch berechnen)
    entry.bonusCalories = 352; // Fester Wert für dieses Beispiel

    // Berechne die Anteile für die Kreise
    double usedCaloriesFraction = entry.usedCalories / user.calorieGoal;
    double bonusCaloriesFraction = entry.bonusCalories / user.calorieGoal;

    return Center(
      child: Container(
        height: 300,
        width: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Benutzerdefinierter Kreis mit CustomPainter
            CustomPaint(
              painter: CalorieCirclePainter(usedCaloriesFraction, bonusCaloriesFraction),
              child: Container(
                height: 260,
                width: 260,
              ),
            ),
            // Text in der Mitte
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${user.calorieGoal - entry.usedCalories}',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'verfügbar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Genutzt: ${entry.usedCalories}',
                  style: TextStyle(
                    fontSize: 18,
                    color:  Color.fromARGB(255, 86, 231, 146),
                  ),
                ),
                Text(
                  'Bonus: ${entry.bonusCalories}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  'Ziel: ${user.calorieGoal}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}