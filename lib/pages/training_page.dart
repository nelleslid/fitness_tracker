// lib/pages/training_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';

class TrainingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // We can later add a provider.of<WorkoutProvider> here
    
    // No AppBar here as it's handled by HomePage
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Center(
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(Icons.fitness_center, size: 64, color: Colors.blue),
                      SizedBox(height: 16),
                      Text(
                        'Trainings-Übersicht',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Hier kannst du deine Aktivitäten tracken.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Add logic to create a new workout
                        },
                        child: Text('Neues Training hinzufügen'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // You can add more workout-related widgets here
          ],
        ),
      ),
    );
  }
}