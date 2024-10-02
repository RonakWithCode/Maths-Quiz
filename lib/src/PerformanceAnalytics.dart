import 'package:shared_preferences/shared_preferences.dart';

class PerformanceAnalytics {
  Future<void> saveScore(int score, String gameMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? scores = prefs.getStringList('leaderboard_$gameMode') ?? [];
    scores.add(score.toString());
    prefs.setStringList('leaderboard_$gameMode', scores);
  }

  Future<List<int>> getLeaderboard(String gameMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? scores = prefs.getStringList('leaderboard_$gameMode');
    if (scores == null) return [];
    return scores.map((s) => int.parse(s)).toList();
  }

  Future<void> clearLeaderboard(String gameMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('leaderboard_$gameMode');
  }
}
