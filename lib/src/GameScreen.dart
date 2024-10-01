import 'dart:math';
import 'package:flutter/material.dart';
import 'ResultScreen.dart';

class GameScreen extends StatefulWidget {
  final String gameMode;
  final String difficulty;
  final int rounds;
  final int wrongAnswersAllowed;

  const GameScreen({
    Key? key,
    required this.gameMode,
    required this.difficulty,
    required this.rounds,
    required this.wrongAnswersAllowed,
  }) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  int wrongs = 0;
  int currentRound = 1;

  late int num1;
  late int num2;
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
        maxNumber = 50;
        break;
      case 'Hard':
      default:
        maxNumber = 100;
        break;
    }

    num1 = Random().nextInt(maxNumber) + 1;
    num2 = Random().nextInt(maxNumber) + 1;

    switch (widget.gameMode) {
      case 'Addition':
        correctAnswer = num1 + num2;
        break;
      case 'Subtraction':
        correctAnswer = num1 >= num2 ? num1 - num2 : num2 - num1;
        break;
      case 'Multiplication':
        correctAnswer = num1 * num2;
        break;
      case 'Division':
        num1 = num1 * num2;
        correctAnswer = num1 ~/ num2;
        break;
      default:
        correctAnswer = 0;
    }

    _generateAnswerOptions();
  }

  void _generateAnswerOptions() {
    answerOptions = [correctAnswer];
    Random random = Random();

    while (answerOptions.length < 4) {
      int option = random.nextInt(correctAnswer + 10) + 1;
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          gameMode: widget.gameMode,
          score: score,
          totalRounds: widget.rounds,
          wrongAnswers: wrongs,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(), // Old background
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTopInfo(),
                  const SizedBox(height: 30),
                  _buildScoreAndWrongs(),
                  const SizedBox(height: 30),
                  _buildQuestion(),
                  const SizedBox(height: 20),
                  _buildAnswerGrid(),
                  const SizedBox(height: 30),
                  _buildBottomButtons(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlueAccent, Colors.pinkAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildTopInfo() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 40, right: 16),
        child: Text(
          "Round: $currentRound / ${widget.rounds}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildScoreAndWrongs() {
    return Column(
      children: [
        Text(
          "Score: $score",
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.yellow,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Wrongs: $wrongs / ${widget.wrongAnswersAllowed}",
          style: const TextStyle(fontSize: 24, color: Colors.redAccent),
        ),
      ],
    );
  }

  Widget _buildQuestion() {
    return Text(
      _getQuestionText(),
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAnswerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.3,
      ),
      itemCount: answerOptions.length,
      itemBuilder: (context, index) {
        return _buildAnswerButton(answerOptions[index]);
      },
    );
  }

  Widget _buildAnswerButton(int answer) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.all(8),
      ),
      onPressed: () {
        _checkAnswer(answer);
      },
      child: Text(
        "$answer",
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildHintButton(),
        _buildFinishButton(),
      ],
    );
  }

  Widget _buildHintButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
        backgroundColor: Colors.amber,
      ),
      onPressed: _showHint,
      child: const Text(
        "?",
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }

  Widget _buildFinishButton() {
    return ElevatedButton(
      onPressed: _endGame,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
      child: const Text(
        "Finish Game",
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  String _getQuestionText() {
    switch (widget.gameMode) {
      case 'Addition':
        return "$num1 + $num2 = ?";
      case 'Subtraction':
        return "$num1 - $num2 = ?";
      case 'Multiplication':
        return "$num1 × $num2 = ?";
      case 'Division':
        return "$num1 ÷ $num2 = ?";
      default:
        return "";
    }
  }

  void _showHint() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('The correct answer is: $correctAnswer'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
