import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultScreen extends StatefulWidget {
  final String gameMode;
  final int score;
  final int totalRounds;
  final int wrongAnswers;

  const ResultScreen({
    Key? key,
    required this.gameMode,
    required this.score,
    required this.totalRounds,
    required this.wrongAnswers,
  }) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String? gender;

  @override
  void initState() {
    super.initState();
    _fetchUserGender();
  }

  Future<void> _fetchUserGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      gender =
          prefs.getString('gender') ?? 'male'; // Default to 'male' if not found
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine colors based on gender
    final primaryColor =
        gender == 'female' ? Colors.pinkAccent : Colors.blueAccent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Over'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGameModeDisplay(primaryColor),
            const SizedBox(height: 30),
            _buildScoreCard(primaryColor),
            const SizedBox(height: 40),
            _buildActionButtons(context, primaryColor),
          ],
        ),
      ),
    );
  }

  // Widget to display the game mode with an icon
  Widget _buildGameModeDisplay(Color primaryColor) {
    return Column(
      children: [
        Icon(
          Icons.sports_esports, // Icon for game mode (customize based on mode)
          size: 60,
          color: primaryColor,
        ),
        const SizedBox(height: 10),
        Text(
          'Game Mode: ${widget.gameMode}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Widget to display score and wrong answers in a card
  Widget _buildScoreCard(Color primaryColor) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Your Score',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${widget.score} / ${widget.totalRounds}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const Divider(height: 30, thickness: 2),
            const Text(
              'Wrong Answers',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${widget.wrongAnswers}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for action buttons (Share and Play Again)
  Widget _buildActionButtons(BuildContext context, Color primaryColor) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _shareResult,
          icon: const Icon(Icons.share, color: Colors.white),
          label: const Text(
            'Share Your Result',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            textStyle: const TextStyle(fontSize: 18),
            backgroundColor: primaryColor, // Dynamic color based on gender
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            textStyle: const TextStyle(fontSize: 18),
            backgroundColor: Colors.greenAccent,
          ),
          child: const Text(
            'Play Again',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  // Share result function
  void _shareResult() {
    final message =
        'I scored ${widget.score} out of ${widget.totalRounds} in ${widget.gameMode} with ${widget.wrongAnswers} wrong answers! Play the game: https://playstore-link.com';
    Share.share(message);
  }
}
