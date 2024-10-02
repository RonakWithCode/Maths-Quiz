import 'dart:math';
import 'package:flutter/material.dart';

class FactorialGameScreen extends StatefulWidget {
  final String difficulty;
  final int rounds;
  final int wrongAnswersAllowed;

  const FactorialGameScreen({
    Key? key,
    required this.difficulty,
    required this.rounds,
    required this.wrongAnswersAllowed,
  }) : super(key: key);

  @override
  _FactorialGameScreenState createState() => _FactorialGameScreenState();
}

class _FactorialGameScreenState extends State<FactorialGameScreen> {
  int score = 0;
  int wrongs = 0;
  int currentRound = 1;
  late int numberToFactorial;
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
        maxNumber = 5;
        break;
      case 'Normal':
        maxNumber = 7;
        break;
      case 'Hard':
      default:
        maxNumber = 10;
        break;
    }

    numberToFactorial = Random().nextInt(maxNumber) + 1;
    correctAnswer = _calculateFactorial(numberToFactorial);

    _generateAnswerOptions();
  }

  int _calculateFactorial(int n) {
    int result = 1;
    for (int i = 1; i <= n; i++) {
      result *= i;
    }
    return result;
  }

  void _generateAnswerOptions() {
    answerOptions = [correctAnswer];
    Random random = Random();

    while (answerOptions.length < 4) {
      int option = random.nextInt(correctAnswer + 50) + 1;
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
    // Navigate to results screen or show results.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Factorial Numbers'),
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
              "$numberToFactorial! = ?",
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
