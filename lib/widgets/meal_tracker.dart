import 'package:flutter/material.dart';
import '../providers/nutrition_provider.dart';
import '../models/meal.dart';
import 'package:provider/provider.dart';

class MealTracker extends StatelessWidget {
  final List<String> categories = ['Morgens', 'Mittags', 'Abends', 'Snacks'];

  @override
  Widget build(BuildContext context) {
    final nutritionProvider = Provider.of<NutritionProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('MAHLZEITEN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ...categories.map((category) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Colors.grey[300]),
              title: Text(category, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Empfohlen kcal'),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  // Einfaches Beispiel für eine Dialog-Form
                  Meal? meal = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Mahlzeit hinzufügen'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: InputDecoration(labelText: 'Name'),
                            onSubmitted: (value) {
                              Navigator.pop(context, Meal(
                                name: value,
                                calories: 500, // Beispielwert
                                macros: {'carbs': 50, 'protein': 30, 'fat': 20},
                              ));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                  if (meal != null) nutritionProvider.addMeal(category, meal);
                },
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}