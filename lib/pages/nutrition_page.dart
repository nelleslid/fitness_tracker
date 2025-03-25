import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final user = User(
      calorieGoal: 3100,
      macroGoals: {'carbs': 366, 'protein': 366, 'fat': 366},
      waterGoal: 3.6,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat('EEEE', 'de').format(nutritionProvider.selectedDate),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[50],
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              // Navigiere zur Statistik-Seite
            },
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: nutritionProvider.selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) nutritionProvider.setDate(picked);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              CalorieTracker(user: user),
              SizedBox(height: 60),
              MacroTracker(user: user),
              SizedBox(height: 60),
              WaterTracker(user: user),
              SizedBox(height: 60),
              MealTracker(),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}