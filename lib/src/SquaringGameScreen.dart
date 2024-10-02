import 'dart:math';
import 'package:flutter/material.dart';

class SquaringGameScreen extends StatefulWidget {
  final String difficulty;
  final int rounds;
  final int wrongAnswersAllowed;

  const SquaringGameScreen({
    Key? key,
    required this.difficulty,
    required this.rounds,
    required this.wrongAnswersAllowed,
  }) : super(key: key);

  @override
  _SquaringGameScreenState createState() => _SquaringGameScreenState();
}

class _SquaringGameScreenState extends State<SquaringGameScreen> {
  int score = 0;
  int wrongs = 0;
  int currentRound = 1;
  late int numberToSquare;
  late int correctAnswer;
  late List<int> answerOptions;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    int maxNumber;
    switch (widget.difficulty) {
      case 'Easy':
        maxNumber = 10;
        break;
      case 'Normal':
        maxNumber = 20;
        break;
      case 'Hard':
      default:
        maxNumber = 50;
        break;
    }

    numberToSquare = Random().nextInt(maxNumber) + 1;
    correctAnswer = numberToSquare * numberToSquare;

    _generateAnswerOptions();
  }

  void _generateAnswerOptions() {
    answerOptions = [correctAnswer];
    Random random = Random();

    while (answerOptions.length < 4) {
      int option = random.nextInt(correctAnswer + 100) + 1;
      if (!answerOptions.contains(option)) {
        answerOptions.add(option);
      }
    }

    answerOptions.shuffle();
  }

  void _checkAnswer(int selectedAnswer) {
    if (selectedAnswer == correctAnswer) {
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
    // Show the user their final score or navigate to the leaderboard, etc.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Squaring Numbers'),
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
              "$numberToSquare² = ?",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemCount: answerOptions.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () => _checkAnswer(answerOptions[index]),
                  child: Text(
                    "${answerOptions[index]}",
                    style: const TextStyle(fontSize: 24),
                  ),
                );
              },
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
