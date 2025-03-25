// lib/providers/nutrition_provider.dart
import 'package:flutter/material.dart';
import '../models/nutrition_entry.dart';
import '../models/meal.dart';
import '../services/supabase_service.dart';

class NutritionProvider with ChangeNotifier {
  NutritionEntry _entry = NutritionEntry();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  
  final SupabaseService _supabaseService = SupabaseService();

  NutritionEntry get entry => _entry;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;

  // Initialisierung, beim Start der App aufrufen
  Future<void> initialize() async {
    await loadData(_selectedDate);
  }

  void updateWater(double change) {
    _entry.water = (_entry.water + change).clamp(0, double.infinity);
    saveData(); // Automatisch speichern bei Änderungen
    notifyListeners();
  }

  void addMeal(String category, Meal meal) {
    _entry.meals[category]!.add(meal);
    _entry.usedCalories += meal.calories;
    meal.macros.forEach((key, value) {
      _entry.macros[key] = (_entry.macros[key] ?? 0) + value;
    });
    saveData(); // Automatisch speichern bei Änderungen
    notifyListeners();
  }

  Future<void> setDate(DateTime date) async {
    _selectedDate = date;
    await loadData(date);
    notifyListeners();
  }

  // Daten aus Supabase laden
  Future<void> loadData(DateTime date) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _supabaseService.getNutritionData(date);
      
      if (data != null) {
        // Daten aus der Datenbank in das Modell umwandeln
        _entry.usedCalories = data['used_calories'] ?? 0;
        _entry.bonusCalories = data['bonus_calories'] ?? 0;
        _entry.water = data['water'] ?? 0.0;
        
        // Macros zuweisen
        _entry.macros = {
          'carbs': data['carbs'] ?? 0.0,
          'protein': data['protein'] ?? 0.0,
          'fat': data['fat'] ?? 0.0,
        };
        
        // Meals aus JSON deserialisieren
        if (data['meals'] != null) {
          Map<String, dynamic> mealsJson = data['meals'];
          _entry.meals = {};
          
          mealsJson.forEach((category, mealsList) {
            _entry.meals[category] = (mealsList as List).map((mealData) {
              return Meal(
                name: mealData['name'],
                calories: mealData['calories'],
                macros: Map<String, double>.from(mealData['macros']),
              );
            }).toList();
          });
        } else {
          _entry.meals = {
            'Morgens': [], 'Mittags': [], 'Abends': [], 'Snacks': []
          };
        }
      } else {
        // Keine Daten gefunden, setze auf Standardwerte
        _entry = NutritionEntry();
      }
    } catch (e) {
      print('Fehler beim Laden der Ernährungsdaten: $e');
      _entry = NutritionEntry();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Daten in Supabase speichern
  Future<void> saveData() async {
    try {
      // Meals für JSON serialisieren
      Map<String, dynamic> mealsJson = {};
      _entry.meals.forEach((category, mealsList) {
        mealsJson[category] = mealsList.map((meal) => {
          'name': meal.name,
          'calories': meal.calories,
          'macros': meal.macros,
        }).toList();
      });

      await _supabaseService.saveNutritionData(_selectedDate, {
        'usedCalories': _entry.usedCalories,
        'bonusCalories': _entry.bonusCalories,
        'macros': _entry.macros,
        'water': _entry.water,
        'meals': mealsJson,
      });
    } catch (e) {
      print('Fehler beim Speichern der Ernährungsdaten: $e');
    }
  }
}