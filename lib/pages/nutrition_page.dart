// lib/pages/nutrition_page.dart
import 'package:fitness_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/nutrition_provider.dart';
import '../models/user.dart';
import '../widgets/calorie_tracker.dart';
import '../widgets/macro_tracker.dart';
import '../widgets/water_tracker.dart';
import '../widgets/meal_tracker.dart';

class NutritionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nutritionProvider = Provider.of<NutritionProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    
    final calorieGoal = 3100;
    final macroGoals = {'carbs': 366, 'protein': 366, 'fat': 366};
    final waterGoal = 3.6;

    // We're no longer using an AppBar here since it's handled by HomePage
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            CalorieTracker(user: user),
            SizedBox(height: 40),
            MacroTracker(user: user),
            SizedBox(height: 40),
            WaterTracker(user: user),
            SizedBox(height: 40),
            MealTracker(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}