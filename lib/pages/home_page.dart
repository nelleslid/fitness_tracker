// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'nutrition_page.dart';
import 'training_page.dart';
import 'profile_page.dart';
import 'statistics_page.dart';
import '../providers/nutrition_provider.dart';
import '../providers/workout_provider.dart';
import '../providers/body_metrics_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  DateTime _selectedDate = DateTime.now();
  late Future<void> _initializationFuture;
  
  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeProviders();
  }
  
  Future<void> _initializeProviders() async {
  try {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // Initialize user provider first since others might depend on it
    await userProvider.initialize();
    
    // Then initialize other providers sequentially not in parallel
    final nutritionProvider = Provider.of<NutritionProvider>(context, listen: false);
    await nutritionProvider.initialize();
    
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    await workoutProvider.initialize();
    
    final bodyMetricsProvider = Provider.of<BodyMetricsProvider>(context, listen: false);
    await bodyMetricsProvider.initialize();
  } catch (e) {
    print("Error initializing providers: $e");
      // Don't rethrow - handle gracefully
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('de', 'DE'),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      
      // Update providers with the new date
      try {
        if (_selectedIndex == 0) {
          Provider.of<NutritionProvider>(context, listen: false).setDate(picked);
        } else if (_selectedIndex == 1) {
          Provider.of<WorkoutProvider>(context, listen: false).setDate(picked);
        }
      } catch (e) {
        print("Error updating date: $e");
      }
    }
  }

  void _navigateToStatistics() {
    Navigator.pushNamed(context, '/statistics');
  }

  // Get the appropriate page based on the selected index
  Widget _getPage() {
    switch (_selectedIndex) {
      case 0:
        return NutritionPage();
      case 1:
        return TrainingPage();
      case 2:
        return ProfilePage();
      default:
        return NutritionPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }
        
        return Scaffold(
          appBar: CustomAppBar(
            selectedDate: _selectedDate,
            onCalendarTap: _selectDate,
            onStatsTap: _navigateToStatistics,
          ),
          body: _getPage(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.fastfood),
                label: 'Ernährung',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center),
                label: 'Training',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        );
      },
    );
  }
}