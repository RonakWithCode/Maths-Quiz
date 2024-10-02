import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mathsgame/src/GameScreen.dart';
import 'package:mathsgame/src/SettingsScreen.dart';
import 'package:mathsgame/src/TablesGameScreen.dart';
import 'package:mathsgame/src/SquaringGameScreen.dart';
import 'package:mathsgame/src/PrimeNumberGameScreen.dart';
import 'package:mathsgame/src/EvenOddGameScreen.dart';
import 'package:mathsgame/src/FactorialGameScreen.dart';
import 'package:mathsgame/src/LeaderboardScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _greetingController;
  late Animation<Offset> _greetingOffsetAnimation;
  late Animation<double> _subtitleBounceAnimation;
  late AnimationController _subtitleController;
  String? gender = 'male'; // Default to 'male', fetch from prefs later

  @override
  void initState() {
    super.initState();
    _greetingController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _greetingOffsetAnimation =
        Tween<Offset>(begin: const Offset(-1.5, 0), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _greetingController, curve: Curves.easeOut));
    _subtitleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _subtitleBounceAnimation =
        CurvedAnimation(parent: _subtitleController, curve: Curves.elasticOut);
    _greetingController.forward();
    _subtitleController.forward();
    _fetchUserGender();
  }

  Future<void> _fetchUserGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      gender = prefs.getString('gender') ?? 'male';
    });
  }

  @override
  void dispose() {
    _greetingController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth < 600 ? 2 : 3;

    final gradientColors = gender == 'male'
        ? [Colors.lightBlueAccent, Colors.pinkAccent]
        : [Colors.pinkAccent, Colors.lightBlueAccent]; // Swap colors for girls

    final beginAli = gender == 'male' ? Alignment.topLeft : Alignment.topRight;
    final beginEnd =
        gender == 'male' ? Alignment.bottomRight : Alignment.bottomLeft;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Fun!'),
        backgroundColor: gender == 'male' ? Colors.blue : Colors.pink,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          // IconButton(
          //   icon: const Icon(Icons.leaderboard),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const LeaderboardScreen(
          //           leaderboardData: [],
          //         ),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: beginAli,
            end: beginEnd,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SlideTransition(
              position: _greetingOffsetAnimation,
              child: Text('Hello, User!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ScaleTransition(
              scale: _subtitleBounceAnimation,
              child: const Text(
                'Choose a game mode to get started!',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildGameModeButton(
                      context, Icons.add, "Addition", Colors.orange),
                  _buildGameModeButton(
                      context, Icons.remove, "Subtraction", Colors.redAccent),
                  _buildGameModeButton(
                      context, Icons.clear, "Multiplication", Colors.green),
                  _buildGameModeButton(
                      context, Icons.percent, "Division", Colors.purple),
                  _buildGameModeButton(
                      context, Icons.table_chart, "Tables", Colors.blueAccent),
                  _buildGameModeButton(
                      context, Icons.exposure, "Squaring", Colors.teal),
                  _buildGameModeButton(context, Icons.verified_user,
                      "Prime Numbers", Colors.amber),
                  _buildGameModeButton(
                      context, Icons.adjust, "Even/Odd", Colors.lime),
                  _buildGameModeButton(
                      context, Icons.star, "Factorial", Colors.indigo),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameModeButton(
      BuildContext context, IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        _showGameModeDialog(context, label);
      },
      child: AnimatedScaleButton(
        color: color,
        icon: icon,
        label: label,
        onTap: () {
          _showGameModeDialog(context, label);
        },
      ),
    );
  }

  void _showGameModeDialog(BuildContext context, String gameMode) {
    String selectedDifficulty = 'Easy'; // Default difficulty level
    bool isAdvanced = false;
    int rounds = 5;
    int wrongAnswers = 3;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final mediaQuery = MediaQuery.of(context);
            double dialogWidth = mediaQuery.size.width * 0.9;
            double maxHeight = mediaQuery.size.height * 0.7; // Maximum height

            return Dialog(
              backgroundColor: Colors.white.withOpacity(0.95),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: dialogWidth,
                  maxHeight: maxHeight, // Constrain height
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Select $gameMode Mode',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color:
                                  gender == 'male' ? Colors.blue : Colors.pink,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10.0,
                            children: [
                              _buildRadioOption(
                                  context, "Easy", selectedDifficulty, (value) {
                                setState(() {
                                  selectedDifficulty = value!;
                                });
                              }),
                              _buildRadioOption(
                                  context, "Normal", selectedDifficulty,
                                  (value) {
                                setState(() {
                                  selectedDifficulty = value!;
                                });
                              }),
                              _buildRadioOption(
                                  context, "Hard", selectedDifficulty, (value) {
                                setState(() {
                                  selectedDifficulty = value!;
                                });
                              }),
                            ],
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isAdvanced = !isAdvanced;
                              });
                            },
                            child: Text(
                              'Advanced Settings',
                              style: TextStyle(
                                color: gender == 'male'
                                    ? Colors.blueAccent
                                    : Colors.pinkAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          if (isAdvanced) ...[
                            const SizedBox(height: 20),
                            _buildRoundAndErrorSetting(
                                context, "Total Rounds", rounds, onAdd: () {
                              setState(() {
                                rounds++;
                              });
                            }, onRemove: () {
                              setState(() {
                                if (rounds > 1) rounds--;
                              });
                            }),
                            const SizedBox(height: 10),
                            _buildRoundAndErrorSetting(
                                context, "Wrong Answers", wrongAnswers,
                                onAdd: () {
                              setState(() {
                                wrongAnswers++;
                              });
                            }, onRemove: () {
                              setState(() {
                                if (wrongAnswers > 1) wrongAnswers--;
                              });
                            }),
                          ],
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel")),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  if (gameMode == "Tables") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TablesGameScreen(
                                          gender: gender!,
                                          difficulty: selectedDifficulty,
                                          rounds: rounds,
                                          wrongAnswers: wrongAnswers,
                                        ),
                                      ),
                                    );
                                  } else if (gameMode == "Squaring Numbers") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SquaringGameScreen(
                                          difficulty: selectedDifficulty,
                                          rounds: rounds,
                                          wrongAnswersAllowed: wrongAnswers,
                                        ),
                                      ),
                                    );
                                  } else if (gameMode == "Prime Numbers") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PrimeNumberGameScreen(
                                          difficulty: selectedDifficulty,
                                          rounds: rounds,
                                          wrongAnswersAllowed: wrongAnswers,
                                        ),
                                      ),
                                    );
                                  } else if (gameMode == "Even/Odd") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EvenOddGameScreen(
                                          difficulty: selectedDifficulty,
                                          rounds: rounds,
                                          wrongAnswersAllowed: wrongAnswers,
                                        ),
                                      ),
                                    );
                                  } else if (gameMode == "Factorial Numbers") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FactorialGameScreen(
                                          difficulty: selectedDifficulty,
                                          rounds: rounds,
                                          wrongAnswersAllowed: wrongAnswers,
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GameScreen(
                                          gameMode: gameMode,
                                          difficulty: selectedDifficulty,
                                          rounds: rounds,
                                          wrongAnswersAllowed: wrongAnswers,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text("Start Game"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRadioOption(BuildContext context, String label,
      String selectedValue, ValueChanged<String?> onChanged) {
    return Row(
      children: [
        Radio<String>(
          value: label,
          groupValue: selectedValue,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }

  Widget _buildRoundAndErrorSetting(
      BuildContext context, String label, int value,
      {required VoidCallback onAdd, required VoidCallback onRemove}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          children: [
            IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.remove_circle, color: Colors.red)),
            Text('$value', style: const TextStyle(fontSize: 16)),
            IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle, color: Colors.green)),
          ],
        ),
      ],
    );
  }
}

class AnimatedScaleButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const AnimatedScaleButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  _AnimatedScaleButtonState createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<AnimatedScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: widget.color.withOpacity(0.6),
                  blurRadius: 10,
                  offset: const Offset(0, 5)),
            ],
          ),
          child: InkWell(
            splashColor: Colors.white.withOpacity(0.3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 60, color: Colors.white),
                const SizedBox(height: 10),
                Text(widget.label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
