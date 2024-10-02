import 'dart:math';
import 'package:flutter/material.dart';

class EvenOddGameScreen extends StatefulWidget {
  final String difficulty;
  final int rounds;
  final int wrongAnswersAllowed;

  const EvenOddGameScreen({
    Key? key,
    required this.difficulty,
    required this.rounds,
    required this.wrongAnswersAllowed,
  }) : super(key: key);

  @override
  _EvenOddGameScreenState createState() => _EvenOddGameScreenState();
}

class _EvenOddGameScreenState extends State<EvenOddGameScreen> {
  int score = 0;
  int wrongs = 0;
  int currentRound = 1;
  late int number;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    int maxNumber;
    switch (widget.difficulty) {
      case 'Easy':
        maxNumber = 50;
        break;
      case 'Normal':
        maxNumber = 100;
        break;
      case 'Hard':
      default:
        maxNumber = 200;
        break;
    }

    number = Random().nextInt(maxNumber) + 1;
  }

  void _checkAnswer(bool userSaidEven) {
    bool isEven = number % 2 == 0;
    if (userSaidEven == isEven) {
      score++;
    } else {
      wrongs++;
    }

    if (wrongs >= widget.wrongAnswersAllowed || currentRound >= widget.rounds) {
      _endGame();
    } else {
      setState(() {
        currentRound++;
        _generateQuestion();
      });
    }
  }

  void _endGame() {
    Navigator.pop(context);
    // Show results or navigate back.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Even/Odd Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Round: $currentRound / ${widget.rounds}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              "$number is Even or Odd?",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _checkAnswer(true),
                  child: const Text("Even"),
                ),
                ElevatedButton(
                  onPressed: () => _checkAnswer(false),
                  child: const Text("Odd"),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              "Score: $score",
              style: const TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}
