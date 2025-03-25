// lib/providers/body_metrics_provider.dart
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class BodyMetricsProvider with ChangeNotifier {
  Map<String, dynamic> _metrics = {
    'weight': 0.0,
    'bodyFat': 0.0,
    'muscleMass': 0.0,
  };
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  
  final SupabaseService _supabaseService = SupabaseService();

  Map<String, dynamic> get metrics => _metrics;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    await loadData(_selectedDate);
  }

  void updateMetrics(Map<String, dynamic> newMetrics) {
    _metrics = {
      ..._metrics,
      ...newMetrics,
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
      final data = await _supabaseService.getBodyMetrics(date);
      
      if (data != null) {
        _metrics = {
          'weight': data['weight'] ?? 0.0,
          'bodyFat': data['body_fat'] ?? 0.0,
          'muscleMass': data['muscle_mass'] ?? 0.0,
        };
      } else {
        _metrics = {
          'weight': 0.0,
          'bodyFat': 0.0,
          'muscleMass': 0.0,
        };
      }
    } catch (e) {
      print('Fehler beim Laden der Körperwerte: $e');
      _metrics = {
        'weight': 0.0,
        'bodyFat': 0.0,
        'muscleMass': 0.0,
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveData() async {
    try {
      await _supabaseService.saveBodyMetrics(_selectedDate, _metrics);
    } catch (e) {
      print('Fehler beim Speichern der Körperwerte: $e');
    }
  }
}