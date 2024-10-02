import 'dart:math';
import 'package:flutter/material.dart';

class PrimeNumberGameScreen extends StatefulWidget {
  final String difficulty;
  final int rounds;
  final int wrongAnswersAllowed;

  const PrimeNumberGameScreen({
    Key? key,
    required this.difficulty,
    required this.rounds,
    required this.wrongAnswersAllowed,
  }) : super(key: key);

  @override
  _PrimeNumberGameScreenState createState() => _PrimeNumberGameScreenState();
}

class _PrimeNumberGameScreenState extends State<PrimeNumberGameScreen> {
  int score = 0;
  int wrongs = 0;
  int currentRound = 1;
  late int number;
  bool? isPrime;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    int maxNumber;
    switch (widget.difficulty) {
      case 'Easy':
        maxNumber = 20;
        break;
      case 'Normal':
        maxNumber = 50;
        break;
      case 'Hard':
      default:
        maxNumber = 100;
        break;
    }

    number = Random().nextInt(maxNumber) + 1;
    isPrime = _checkPrime(number);
  }

  bool _checkPrime(int number) {
    if (number < 2) return false;
    for (int i = 2; i <= sqrt(number).toInt(); i++) {
      if (number % i == 0) return false;
    }
    return true;
  }

  void _checkAnswer(bool userSaidPrime) {
    if (userSaidPrime == isPrime) {
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
    // Handle game end logic or show results.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prime Number Game'),
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
              "$number is a Prime Number?",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _checkAnswer(true),
                  child: const Text("Yes"),
                ),
                ElevatedButton(
                  onPressed: () => _checkAnswer(false),
                  child: const Text("No"),
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
