// lib/main.dart (aktualisiert)
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/nutrition_provider.dart';
import 'providers/workout_provider.dart';
import 'providers/body_metrics_provider.dart';
import 'providers/user_provider.dart';
import 'providers/statistics_provider.dart';
import 'pages/auth/auth_wrapper.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/home_page.dart';
import 'pages/nutrition_page.dart';
import 'pages/training_page.dart';
import 'pages/statistics_page.dart';
import 'pages/profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('de', null);
  await Supabase.initialize(
    url: 'https://xdkinmufrapcszbmopyr.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhka2lubXVmcmFwY3N6Ym1vcHlyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4OTg3MzksImV4cCI6MjA1ODQ3NDczOX0.TEzllMgcDOeFnPwu7BjOQwofkueyp68bGuxRphTqGko',
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NutritionProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => BodyMetricsProvider()),
        ChangeNotifierProvider(create: (_) => StatisticsProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('de', 'DE'),
        const Locale('en', 'US'),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/statistics': (context) => StatisticsPage(),
      },
    );
  }
}