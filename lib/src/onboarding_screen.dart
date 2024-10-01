import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedClass = '1';
  int _age = 5;
  String _gender = 'male'; // Default to male

  // Define different color themes for Boy and Girl
  Color _getPrimaryColor() {
    return _gender == 'male' ? Colors.blueAccent : Colors.pinkAccent;
  }

  Future<void> _saveUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _nameController.text);
    await prefs.setString('class', _selectedClass);
    await prefs.setInt('age', _age);
    await prefs.setString('gender', _gender); // Save gender

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevents overflow when keyboard appears
      appBar: AppBar(
        title: const Text('Let\'s Get Started!'),
        backgroundColor:
            _getPrimaryColor(), // Set dynamic color based on gender
      ),
      body: SingleChildScrollView(
        // Allows the screen to scroll when keyboard shows up
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20), // Adds spacing at the top
            Text(
              "What's your name?",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Enter your name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedClass,
              items: ['1', '2', '3', '4', '5'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text("Class $value"),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: "Select your class",
                border: OutlineInputBorder(),
              ),
              onChanged: (newValue) {
                setState(() {
                  _selectedClass = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text("How old are you?"),
            Slider(
              value: _age.toDouble(),
              min: 5,
              max: 15,
              divisions: 10,
              label: _age.toString(),
              onChanged: (value) {
                setState(() {
                  _age = value.toInt();
                });
              },
            ),
            const SizedBox(height: 20),
            const Text("Select your gender:"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<String>(
                  value: 'male',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                ),
                const Text("Boy"),
                const SizedBox(width: 20),
                Radio<String>(
                  value: 'female',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                ),
                const Text("Girl"),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserPreferences,
              style: ElevatedButton.styleFrom(
                backgroundColor: _getPrimaryColor(), // Use gender-based color
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text("Save & Start"),
            ),
          ],
        ),
      ),
    );
  }
}
