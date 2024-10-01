import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart'; // Import your HomeScreen widget

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedClass = '1';
  int _age = 5;
  String _gender = 'male'; // Default to male

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load existing data on init
  }

  // Function to load saved user data
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('username') ?? '';
      _selectedClass = prefs.getString('class') ?? '1';
      _age = prefs.getInt('age') ?? 5;
      _gender = prefs.getString('gender') ?? 'male';
    });
  }

  // Function to save updated user data
  Future<void> _saveUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _nameController.text);
    await prefs.setString('class', _selectedClass);
    await prefs.setInt('age', _age);
    await prefs.setString('gender', _gender); // Save gender

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User information updated successfully!')),
    );

    // After saving, navigate to HomeScreen and remove SettingsScreen from the stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  // Define different color themes for Boy and Girl
  Color _getPrimaryColor() {
    return _gender == 'male' ? Colors.blueAccent : Colors.pinkAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor:
            _getPrimaryColor(), // Set dynamic color based on gender
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20), // Adds spacing at the top
            Text(
              "Update your information",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Name Field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Enter your name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Class Dropdown
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

            // Age Slider
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

            // Gender Radio Buttons
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

            // Save Button
            ElevatedButton(
              onPressed: _saveUserPreferences,
              style: ElevatedButton.styleFrom(
                backgroundColor: _getPrimaryColor(), // Gender-based color
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
