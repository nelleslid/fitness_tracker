// lib/providers/statistics_provider.dart
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class StatisticsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _nutritionStats = [];
  List<Map<String, dynamic>> _bodyMetricsStats = [];
  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _endDate = DateTime.now();
  bool _isLoading = false;
  
  final SupabaseService _supabaseService = SupabaseService();

  List<Map<String, dynamic>> get nutritionStats => _nutritionStats;
  List<Map<String, dynamic>> get bodyMetricsStats => _bodyMetricsStats;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    await loadData();
  }

  Future<void> setDateRange(DateTime start, DateTime end) async {
    _startDate = start;
    _endDate = end;
    await loadData();
    notifyListeners();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Lade Statistiken für Ernährung
      _nutritionStats = await _supabaseService.getNutritionStats(_startDate, _endDate);
      
      // Lade Statistiken für Körperwerte
      _bodyMetricsStats = await _supabaseService.getBodyMetricsStats(_startDate, _endDate);
    } catch (e) {
      print('Fehler beim Laden der Statistiken: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}