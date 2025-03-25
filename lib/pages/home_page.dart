// lib/pages/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'nutrition.dart';
import 'training.dart';
import 'profile.dart';
import '../providers/nutrition_provider.dart';
import '../providers/workout_provider.dart';
import '../providers/body_metrics_provider.dart';
import '../providers/user_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();
    // Provider initialisieren, wenn der HomeScreen geladen wird
    Future.microtask(() => _initializeProviders());
  }
  
  Future<void> _initializeProviders() async {
    await Provider.of<UserProvider>(context, listen: false).initialize();
    await Provider.of<NutritionProvider>(context, listen: false).initialize();
    await Provider.of<WorkoutProvider>(context, listen: false).initialize();
    await Provider.of<BodyMetricsProvider>(context, listen: false).initialize();
  }

  // Liste der Seiten
  final List<Widget> _pages = [
    NutritionPage(),
    TrainingPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
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
  }
}