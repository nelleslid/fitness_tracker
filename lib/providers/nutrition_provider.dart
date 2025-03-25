import 'package:flutter/material.dart';
import '../models/nutrition_entry.dart';
import '../models/meal.dart';
class NutritionProvider with ChangeNotifier {
  NutritionEntry _entry = NutritionEntry();
  DateTime _selectedDate = DateTime.now();

  NutritionEntry get entry => _entry;
  DateTime get selectedDate => _selectedDate;

  void updateWater(double change) {
    _entry.water = (_entry.water + change).clamp(0, double.infinity);
    notifyListeners();
  }

  void addMeal(String category, Meal meal) {
    _entry.meals[category]!.add(meal);
    _entry.usedCalories += meal.calories;
    meal.macros.forEach((key, value) {
      _entry.macros[key] = (_entry.macros[key] ?? 0) + value;
    });
    notifyListeners();
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    // Hier später Daten für das Datum laden (z.B. aus SharedPreferences)
    notifyListeners();
  }
}