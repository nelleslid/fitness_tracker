// lib/pages/auth/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';
import '../../pages/home_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (!mounted) return;
      
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else if (event == AuthChangeEvent.signedOut) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  // In AuthWrapper
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Future(() {
        final user = Supabase.instance.client.auth.currentUser;
        return user != null;
      }),
      builder: (context, snapshot) {
        // Don't use addPostFrameCallback here - it's causing double navigation
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        // Replace this with direct return of pages
        if (snapshot.data!) {
          return HomePage();  // Direct return instead of navigation
        } else {
          return LoginPage();  // Direct return instead of navigation
        }
      },
    );
  }
}