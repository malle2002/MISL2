import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_services.dart';

class JokeOfTheDayScreen extends StatefulWidget {
  @override
  _JokeOfTheDayScreenState createState() => _JokeOfTheDayScreenState();
}

class _JokeOfTheDayScreenState extends State<JokeOfTheDayScreen> {
  String jokeSetup = "Loading...";
  String jokePunchline = "";
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchJokeOfTheDay();
  }

  Future<void> fetchJokeOfTheDay() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);

    final savedDate = prefs.getString('jokeDate');
    if (savedDate == today) {
      final savedJoke = prefs.getString('jokeOfTheDay');
      if (savedJoke != null) {
        final Map<String, dynamic> joke = json.decode(savedJoke);
        setState(() {
          jokeSetup = joke['setup'] as String;
          jokePunchline = joke['punchline'] as String;
        });
        return;
      }
    }

    try {
      final randomJoke = await apiService.getRandomJoke();
      prefs.setString('jokeDate', today);
      prefs.setString('jokeOfTheDay', json.encode(randomJoke));
      setState(() {
        jokeSetup = randomJoke['setup'];
        jokePunchline = randomJoke['punchline'];
      });
    } catch (e) {
      setState(() {
        jokeSetup = "Failed to load joke.";
        jokePunchline = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Joke of the Day'),
      ),
      body: Center(
        child: jokeSetup == "Loading..."
            ? const CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                jokeSetup,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                jokePunchline,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
