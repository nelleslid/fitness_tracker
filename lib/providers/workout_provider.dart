// lib/providers/workout_provider.dart
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class WorkoutProvider with ChangeNotifier {
  Map<String, dynamic> _workoutData = {
    'workoutType': '',
    'durationMinutes': 0,
    'caloriesBurned': 0,
    'exercises': [],
  };
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  
  final SupabaseService _supabaseService = SupabaseService();

  Map<String, dynamic> get workoutData => _workoutData;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    await loadData(_selectedDate);
  }

  void updateWorkout(Map<String, dynamic> newData) {
    _workoutData = {
      ..._workoutData,
      ...newData,
    };
    saveData();
    notifyListeners();
  }

  Future<void> setDate(DateTime date) async {
    _selectedDate = date;
    await loadData(date);
    notifyListeners();
  }

  Future<void> loadData(DateTime date) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _supabaseService.getWorkoutData(date);
      
      if (data != null) {
        _workoutData = data;
      } else {
        _workoutData = {
          'workoutType': '',
          'durationMinutes': 0,
          'caloriesBurned': 0,
          'exercises': [],
        };
      }
    } catch (e) {
      print('Fehler beim Laden der Trainingsdaten: $e');
      _workoutData = {
        'workoutType': '',
        'durationMinutes': 0,
        'caloriesBurned': 0,
        'exercises': [],
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveData() async {
    try {
      await _supabaseService.saveWorkoutData(_selectedDate, _workoutData);
    } catch (e) {
      print('Fehler beim Speichern der Trainingsdaten: $e');
    }
  }
}