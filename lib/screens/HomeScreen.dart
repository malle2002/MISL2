import 'package:flutter/material.dart';
import 'package:lab3/screens/FavoritesScreen.dart';
import 'package:lab3/screens/JokeCategoryScreen.dart';
import 'package:lab3/screens/RandomJokeScreen.dart';
import 'package:lab3/services/api_services.dart';
import 'package:lab3/widgets/joke_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> favoriteJokes = [];
  final ApiService apiService = ApiService();

  String currentCategory = 'general';
  final List<String> categories = ['general', 'programming', 'dad', 'knock-knock'];

  void addFavorite(String setup, String punchline) {
    setState(() {
      final existingJoke = favoriteJokes.firstWhere(
            (joke) => joke['setup'] == setup && joke['punchline'] == punchline,
        orElse: () => {},
      );

      if (existingJoke.isEmpty) {
        favoriteJokes.add({'setup': setup, 'punchline': punchline});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to favorites!')),
        );
      } else {
        favoriteJokes.removeWhere((joke) =>
        joke['setup'] == setup && joke['punchline'] == punchline);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from favorites!')),
        );
      }
    });
  }

  bool isFavorite(String setup, String punchline) {
    return favoriteJokes.any(
          (joke) => joke['setup'] == setup && joke['punchline'] == punchline,
    );
  }

  Future<void> navigateToJokeOfTheDay() async {
    Navigator.pushNamed(context, '/jokeOfTheDay');
  }

  void navigateToFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesScreen(
          favoriteJokes: favoriteJokes,
          removeFavorite: (setup, punchline) {
            removeFavorite(setup, punchline);
          },
        ),
      ),
    );
  }

  void removeFavorite(String setup, String punchline) {
    setState(() {
      favoriteJokes.removeWhere(
              (joke) => joke['setup'] == setup && joke['punchline'] == punchline);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed from favorites!')),
    );
  }

  void navigateToRandomJoke() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RandomJokeScreen(
          favoriteJokes: favoriteJokes,
          addFavorite: addFavorite,
          removeFavorite: removeFavorite,
          isFavorite: isFavorite,
        ),
      ),
    );
  }

  void navigateToJokeCategoryScreen(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JokeCategoryScreen(
          type: category,
          favoriteJokes: favoriteJokes,
          addFavorite: addFavorite,
          isFavorite: isFavorite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jokes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: navigateToFavorites,
          ),
          IconButton(
            icon: const Icon(Icons.casino),
            onPressed: navigateToRandomJoke,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: categories.map((category) {
                return ElevatedButton(
                  onPressed: () => navigateToJokeCategoryScreen(category),
                  style: ElevatedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: apiService.getJokesByType(currentCategory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No jokes available."));
                } else {
                  final jokes = snapshot.data!;
                  return ListView.builder(
                    itemCount: jokes.length,
                    itemBuilder: (context, index) {
                      final joke = jokes[index];
                      return GestureDetector(
                        onTap: () {
                          navigateToJokeCategoryScreen(joke['type']);
                        },
                        child: JokeCard(
                          type: joke['type'],
                          setup: joke['setup'],
                          punchline: joke['punchline'],
                          onFavorite: () =>
                              addFavorite(joke['setup'], joke['punchline']),
                          isFavorite: isFavorite(joke['setup'], joke['punchline']),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: navigateToJokeOfTheDay,
            child: const Text('View Joke of the Day'),
          ),
        ],
      ),
    );
  }
}
