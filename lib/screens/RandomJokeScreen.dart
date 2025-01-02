import 'package:flutter/material.dart';
import 'package:lab3/services/api_services.dart';
import 'package:lab3/widgets/joke_card.dart';

class RandomJokeScreen extends StatefulWidget {
  final List<Map<String, String>> favoriteJokes;
  final Function addFavorite;
  final Function removeFavorite;
  final Function isFavorite;

  RandomJokeScreen({
    required this.favoriteJokes,
    required this.addFavorite,
    required this.removeFavorite,
    required this.isFavorite,
  });

  @override
  _RandomJokeScreenState createState() => _RandomJokeScreenState();
}

class _RandomJokeScreenState extends State<RandomJokeScreen> {
  final ApiService apiService = ApiService();
  late Future<Map<String, dynamic>> randomJoke;

  @override
  void initState() {
    super.initState();
    randomJoke = apiService.getRandomJoke();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Random Joke")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: randomJoke,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No joke available'));
          } else {
            final joke = snapshot.data!;
            final setup = joke['setup'];
            final punchline = joke['punchline'];
            final type = joke['type'];
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  JokeCard(
                    type: type,
                    setup: setup,
                    punchline: punchline,
                    onFavorite: () {
                      setState(() {
                        if (widget.isFavorite(setup, punchline)) {
                          widget.removeFavorite(setup, punchline);
                        } else {
                          widget.addFavorite(setup, punchline);
                        }
                      });
                    },
                    isFavorite: widget.isFavorite(setup, punchline),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
