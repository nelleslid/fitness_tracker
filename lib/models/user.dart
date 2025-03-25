class User {
  final int calorieGoal;
  final Map<String, double> macroGoals; // z.B. {'carbs': 160, 'protein': 160, 'fat': 160}
  final double waterGoal;

  User({required this.calorieGoal, required this.macroGoals, required this.waterGoal});
}