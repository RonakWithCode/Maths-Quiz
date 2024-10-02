import 'dart:math';
import 'package:flutter/material.dart';

class TablesGameScreen extends StatefulWidget {
  final String gender;
  final String difficulty;
  final int rounds;
  final int wrongAnswers;

  const TablesGameScreen({
    Key? key,
    required this.gender,
    required this.difficulty,
    required this.rounds,
    required this.wrongAnswers,
  }) : super(key: key);

  @override
  _TablesGameScreenState createState() => _TablesGameScreenState();
}

class _TablesGameScreenState extends State<TablesGameScreen> {
  late List<int> tableNumbers;
  late List<int?> userInputs;
  late int tableBase;
  final List<int> blankPositions = [];
  final _formKey = GlobalKey<FormState>();
  int currentRound = 1;
  int points = 0;
  int wrongAnswersCount = 0;

  @override
  void initState() {
    super.initState();
    _generateRandomTable();
  }

  // Function to generate a random table with random blanks
  void _generateRandomTable() {
    tableBase = Random().nextInt(11) +
        2; // Generate a random table base between 2 and 12
    tableNumbers = List.generate(
        10, (index) => tableBase * (index + 1)); // Generate table for 1 to 10
    userInputs = List.filled(10, null);
    blankPositions.clear();
    while (blankPositions.length < 3) {
      int randomPosition = Random().nextInt(10);
      if (!blankPositions.contains(randomPosition)) {
        blankPositions.add(randomPosition);
      }
    }
    setState(() {});
  }

  // Function to validate user's answer and check if the table is correctly filled
  bool _validateUserInput() {
    for (int blankIndex in blankPositions) {
      if (userInputs[blankIndex] != tableNumbers[blankIndex]) {
        return false;
      }
    }
    return true;
  }

  // Function to handle submission of answers
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      bool isCorrect = _validateUserInput();
      if (isCorrect) {
        points += 10; // Add points if correct
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Correct! You completed the table.")),
        );
      } else {
        wrongAnswersCount++;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Incorrect, try again.")),
        );
      }

      if (currentRound < widget.rounds &&
          wrongAnswersCount < widget.wrongAnswers) {
        setState(() {
          currentRound++;
          _generateRandomTable();
        });
      } else {
        _endGame();
      }
    }
  }

  // Function to end the game
  void _endGame() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Game Over! You scored $points points.")),
    );
    Navigator.pop(context); // Return to home screen or previous screen
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = widget.gender == 'male'
        ? [Colors.lightBlueAccent, Colors.pinkAccent]
        : [Colors.pinkAccent, Colors.lightBlueAccent];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tables Game'),
        backgroundColor:
            widget.gender == 'male' ? Colors.blueAccent : Colors.pinkAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateRandomTable,
            tooltip: 'New Table',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Wrap content in SingleChildScrollView to avoid overflow
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Complete the table of $tableBase',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'Round: $currentRound / ${widget.rounds}',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                  },
                  children: _buildTableRows(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Submit"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Points: $points',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build the table rows with blanks
  List<TableRow> _buildTableRows() {
    return List.generate(10, (index) {
      return TableRow(
        children: [
          Text(
            '${tableBase} x ${index + 1} = ',
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          blankPositions.contains(index)
              ? Padding(
                  padding: const EdgeInsets.all(
                      4.0), // Reduced padding for input fields
                  child: SizedBox(
                    height: 40, // Fixed height to avoid large input box
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        userInputs[index] = int.tryParse(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter number';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: ' ? ',
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${tableNumbers[index]}',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
        ],
      );
    });
  }
}
