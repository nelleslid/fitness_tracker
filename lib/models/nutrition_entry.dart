import 'package:fitness_app/models/meal.dart';

class NutritionEntry {
  int usedCalories = 0;
  int bonusCalories = 0;
  Map<String, double> macros = {'carbs': 0, 'protein': 0, 'fat': 0};
  double water = 0;
  Map<String, List<Meal>> meals = {
    'Morgens': [], 'Mittags': [], 'Abends': [], 'Snacks': []
  };

  NutritionEntry();
}