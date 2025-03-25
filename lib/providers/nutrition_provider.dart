// lib/providers/nutrition_provider.dart
import 'package:flutter/material.dart';
import '../models/nutrition_entry.dart';
import '../models/meal.dart';
import '../services/supabase_service.dart';

class NutritionProvider with ChangeNotifier {
  NutritionEntry _entry = NutritionEntry();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  bool _isInitialized = false;
  
  final SupabaseService _supabaseService = SupabaseService();

  NutritionEntry get entry => _entry;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  // Initialisierung, beim Start der App aufrufen
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await loadData(_selectedDate);
      _isInitialized = true;
    } catch (e) {
      print('Fehler bei der Initialisierung: $e');
      // Fallback to default values
      _entry = NutritionEntry();
      _isInitialized = true; // Still mark as initialized to prevent loops
    }
  }

  void updateWater(double change) {
    if (!_isInitialized) {
      print('Provider not initialized');
      return;
    }
    
    _entry.water = (_entry.water + change).clamp(0, double.infinity);
    saveData(); // Automatisch speichern bei Änderungen
    notifyListeners();
  }

  void addMeal(String category, Meal meal) {
    if (!_isInitialized) {
      print('Provider not initialized');
      return;
    }
    
    // Stelle sicher, dass die Kategorie existiert
    _entry.meals.putIfAbsent(category, () => []);
    
    // Jetzt können wir sicher sein, dass die Liste existiert
    _entry.meals[category]?.add(meal);
    _entry.usedCalories += meal.calories;
    
    meal.macros.forEach((key, value) {
      _entry.macros.putIfAbsent(key, () => 0);
      _entry.macros[key] = (_entry.macros[key] ?? 0) + value;
    });
    
    saveData();
    notifyListeners();
  }

  Future<void> setDate(DateTime date) async {
    _selectedDate = date;
    try {
      await loadData(date);
    } catch (e) {
      print('Fehler beim Setzen des Datums: $e');
      // Fallback to default values
      _entry = NutritionEntry();
    }
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
        _entry.meals = {
          'Morgens': [], 'Mittags': [], 'Abends': [], 'Snacks': []
        };
        
        if (data['meals'] != null) {
          Map<String, dynamic> mealsJson = data['meals'];
          
          mealsJson.forEach((category, mealsList) {
            if (mealsList is List) {
              _entry.meals[category] = mealsList.map((mealData) {
                return Meal(
                  name: mealData['name'] ?? 'Unbenannt',
                  calories: mealData['calories'] ?? 0,
                  macros: Map<String, double>.from(mealData['macros'] ?? {'carbs': 0.0, 'protein': 0.0, 'fat': 0.0}),
                );
              }).toList();
            }
          });
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
    if (!_isInitialized) return;
    
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