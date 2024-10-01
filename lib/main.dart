import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/home_screen.dart';
import 'src/onboarding_screen.dart';

void main() {
  runApp(const MathGameApp());
}

class MathGameApp extends StatelessWidget {
  const MathGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getGenderPreference(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        String? gender = snapshot.data;
        return MaterialApp(
          title: 'Kids Math Game',
          theme: gender == 'male' ? _buildBoyTheme() : _buildGirlTheme(),
          
          home: const SplashScreen(),
        );
      },
    );
  }

  Future<String?> _getGenderPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('gender');
  }

  ThemeData _buildBoyTheme() {
    return ThemeData(
      primaryColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.lightBlue.shade50,
      fontFamily: 'ComicSans',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 30.0,
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          fontSize: 18.0,
          color: Colors.black,
        ),
      ),
    );
  }

  ThemeData _buildGirlTheme() {
    return ThemeData(
      primaryColor: Colors.pinkAccent,
      scaffoldBackgroundColor: Colors.pink.shade50,
      fontFamily: 'ComicSans',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 30.0,
          color: Colors.pinkAccent,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          fontSize: 18.0,
          color: Colors.black,
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<bool> _isFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') == null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isFirstTimeUser(),
      
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return snapshot.data == true
              ? const OnboardingScreen()
              : const HomeScreen();
        }
      },
    );
  }
}
