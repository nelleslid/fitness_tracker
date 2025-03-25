// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // Singleton-Pattern für den Service
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  // Getter für den Supabase-Client
  SupabaseClient get supabase => Supabase.instance.client;

  // Initialisierungsmethode
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://xdkinmufrapcszbmopyr.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhka2lubXVmcmFwY3N6Ym1vcHlyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTg3MzksImV4cCI6MjA1ODQ3NDczOX0.TEzllMgcDOeFnPwu7BjOQwofkueyp68bGuxRphTqGko',
    );
  }

  // Benutzer-Authentifizierung
  User? get currentUser => supabase.auth.currentUser;
  AuthState get authState => supabase.auth.currentSession != null 
      ? AuthState.authenticated 
      : AuthState.unauthenticated;

  // Methoden für Ernährungsdaten
  Future<void> saveNutritionData(DateTime date, Map<String, dynamic> data) async {
    final userId = currentUser?.id;
    if (userId == null) throw Exception('Benutzer nicht angemeldet');

    final dateString = date.toIso8601String().split('T')[0];

    await supabase
        .from('nutrition')
        .upsert({
          'user_id': userId,
          'date': dateString,
          'used_calories': data['usedCalories'],
          'bonus_calories': data['bonusCalories'],
          'carbs': data['macros']['carbs'],
          'protein': data['macros']['protein'],
          'fat': data['macros']['fat'],
          'water': data['water'],
          'meals': data['meals'], // JSON-Feld für Mahlzeiten
        });
  }

  Future<Map<String, dynamic>?> getNutritionData(DateTime date) async {
    final userId = currentUser?.id;
    if (userId == null) throw Exception('Benutzer nicht angemeldet');

    final dateString = date.toIso8601String().split('T')[0];

    final data = await supabase
        .from('nutrition')
        .select()
        .eq('user_id', userId)
        .eq('date', dateString)
        .maybeSingle();

    return data;
  }

  // Methoden für Trainingsdaten
  Future<void> saveWorkoutData(DateTime date, Map<String, dynamic> workoutData) async {
    final userId = currentUser?.id;
    if (userId == null) throw Exception('Benutzer nicht angemeldet');

    final dateString = date.toIso8601String().split('T')[0];

    // Speichern der Workout-Daten
    final workoutResult = await supabase
        .from('workouts')
        .upsert({
          'user_id': userId,
          'date': dateString,
          'workout_type': workoutData['workoutType'],
          'duration_minutes': workoutData['durationMinutes'],
          'calories_burned': workoutData['caloriesBurned'],
          // Weitere Felder je nach Bedarf
        })
        .select()
        .single();

    // Wenn es Übungen gibt, speichere diese
    if (workoutData['exercises'] != null) {
      // Lösche zuerst alle vorhandenen Übungen für dieses Workout
      await supabase
          .from('exercises')
          .delete()
          .eq('workout_id', workoutResult['id']);

      // Füge dann neue Übungen hinzu
      for (var exercise in workoutData['exercises']) {
        await supabase
            .from('exercises')
            .insert({
              'workout_id': workoutResult['id'],
              'exercise_name': exercise['name'],
              'sets': exercise['sets'],
              'reps': exercise['reps'],
              'weight': exercise['weight'],
            });
      }
    }
  }

  Future<Map<String, dynamic>?> getWorkoutData(DateTime date) async {
    final userId = currentUser?.id;
    if (userId == null) throw Exception('Benutzer nicht angemeldet');

    final dateString = date.toIso8601String().split('T')[0];

    // Hole das Workout
    final workout = await supabase
        .from('workouts')
        .select()
        .eq('user_id', userId)
        .eq('date', dateString)
        .maybeSingle();

    if (workout == null) return null;

    // Hole zugehörige Übungen
    final exercises = await supabase
        .from('exercises')
        .select()
        .eq('workout_id', workout['id']);

    // Kombiniere die Daten
    workout['exercises'] = exercises;
    return workout;
  }

  // Methoden für Körperwerte
  Future<void> saveBodyMetrics(DateTime date, Map<String, dynamic> metrics) async {
    final userId = currentUser?.id;
    if (userId == null) throw Exception('Benutzer nicht angemeldet');

    final dateString = date.toIso8601String().split('T')[0];

    await supabase
        .from('body_metrics')
        .upsert({
          'user_id': userId,
          'date': dateString,
          'weight': metrics['weight'],
          'body_fat': metrics['bodyFat'],
          'muscle_mass': metrics['muscleMass'],
          // Weitere Körperwerte je nach Bedarf
        });
  }

  Future<Map<String, dynamic>?> getBodyMetrics(DateTime date) async {
    final userId = currentUser?.id;
    if (userId == null) throw Exception('Benutzer nicht angemeldet');

    final dateString = date.toIso8601String().split('T')[0];

    final data = await supabase
        .from('body_metrics')
        .select()
        .eq('user_id', userId)
        .eq('date', dateString)
        .maybeSingle();

    return data;
  }

  // Methoden für Statistikdaten
  Future<List<Map<String, dynamic>>> getNutritionStats(
      DateTime startDate, DateTime endDate) async {
    final userId = currentUser?.id;
    if (userId == null) throw Exception('Benutzer nicht angemeldet');

    final startDateString = startDate.toIso8601String().split('T')[0];
    final endDateString = endDate.toIso8601String().split('T')[0];

    final data = await supabase
        .from('nutrition')
        .select()
        .eq('user_id', userId)
        .gte('date', startDateString)
        .lte('date', endDateString)
        .order('date');

    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<Map<String, dynamic>>> getBodyMetricsStats(
      DateTime startDate, DateTime endDate) async {
    final userId = currentUser?.id;
    if (userId == null) throw Exception('Benutzer nicht angemeldet');

    final startDateString = startDate.toIso8601String().split('T')[0];
    final endDateString = endDate.toIso8601String().split('T')[0];

    final data = await supabase
        .from('body_metrics')
        .select()
        .eq('user_id', userId)
        .gte('date', startDateString)
        .lte('date', endDateString)
        .order('date');

    return List<Map<String, dynamic>>.from(data);
  }

  // User-Präferenzen speichern (Ziele, etc.)
  Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    final userId = currentUser?.id;
    if (userId == null) throw Exception('Benutzer nicht angemeldet');

    await supabase
        .from('user_preferences')
        .upsert({
          'user_id': userId,
          'calorie_goal': preferences['calorieGoal'],
          'macro_goals': preferences['macroGoals'], // JSON-Feld
          'water_goal': preferences['waterGoal'],
          // Weitere Präferenzen
        });
  }

  Future<Map<String, dynamic>?> getUserPreferences() async {
    final userId = currentUser?.id;
    if (userId == null) throw Exception('Benutzer nicht angemeldet');

    final data = await supabase
        .from('user_preferences')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    return data;
  }
}

enum AuthState {
  authenticated,
  unauthenticated
}