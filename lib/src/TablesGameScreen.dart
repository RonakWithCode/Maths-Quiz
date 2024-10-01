import 'package:flutter/material.dart';

class TablesGameScreen extends StatelessWidget {
  const TablesGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tables Game'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text(
          'Tables Game Coming Soon!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
