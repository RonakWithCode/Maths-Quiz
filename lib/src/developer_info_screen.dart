import 'package:flutter/material.dart';

class DeveloperInfoScreen extends StatelessWidget {
  const DeveloperInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Developer: John Doe", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Contact: johndoe@example.com",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("GitHub: github.com/johndoe", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
