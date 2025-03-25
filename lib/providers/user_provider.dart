// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/supabase_service.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
    calorieGoal: 3100,
    macroGoals: {'carbs': 366, 'protein': 366, 'fat': 366},
    waterGoal: 3.6,
  );
  bool _isLoading = false;
  
  final SupabaseService _supabaseService = SupabaseService();

  User get user => _user;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    await loadUserPreferences();
  }

  void updateUserPreferences({
    int? calorieGoal,
    Map<String, double>? macroGoals,
    double? waterGoal,
  }) {
    if (calorieGoal != null) {
      _user = User(
        calorieGoal: calorieGoal,
        macroGoals: _user.macroGoals,
        waterGoal: _user.waterGoal,
      );
    }
    
    if (macroGoals != null) {
      _user = User(
        calorieGoal: _user.calorieGoal,
        macroGoals: macroGoals,
        waterGoal: _user.waterGoal,
      );
    }
    
    if (waterGoal != null) {
      _user = User(
        calorieGoal: _user.calorieGoal,
        macroGoals: _user.macroGoals,
        waterGoal: waterGoal,
      );
    }
    
    saveUserPreferences();
    notifyListeners();
  }

  Future<void> loadUserPreferences() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await _supabaseService.getUserPreferences();
      
      if (prefs != null) {
        _user = User(
          calorieGoal: prefs['calorie_goal'] ?? 3100,
          macroGoals: Map<String, double>.from(prefs['macro_goals'] ?? {'carbs': 366, 'protein': 366, 'fat': 366}),
          waterGoal: prefs['water_goal'] ?? 3.6,
        );
      }
    } catch (e) {
      print('Fehler beim Laden der Benutzereinstellungen: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveUserPreferences() async {
    try {
      await _supabaseService.saveUserPreferences({
        'calorieGoal': _user.calorieGoal,
        'macroGoals': _user.macroGoals,
        'waterGoal': _user.waterGoal,
      });
    } catch (e) {
      print('Fehler beim Speichern der Benutzereinstellungen: $e');
    }
  }
}