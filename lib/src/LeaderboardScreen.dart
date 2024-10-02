import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboardData;

  const LeaderboardScreen({Key? key, required this.leaderboardData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: ListView.builder(
        itemCount: leaderboardData.length,
        itemBuilder: (context, index) {
          final playerData = leaderboardData[index];
          return ListTile(
            leading: Text('${index + 1}'),
            title: Text(playerData['name']),
            subtitle: Text('Score: ${playerData['score']}'),
          );
        },
      ),
    );
  }
}
