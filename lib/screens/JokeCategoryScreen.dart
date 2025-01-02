import 'package:flutter/material.dart';
import 'package:lab3/services/api_services.dart';
import 'package:lab3/widgets/joke_card.dart';

class JokeCategoryScreen extends StatefulWidget {
  final String type;
  final List<Map<String, String>> favoriteJokes;
  final Function addFavorite;
  final Function isFavorite;

  JokeCategoryScreen({
    required this.type,
    required this.favoriteJokes,
    required this.addFavorite,
    required this.isFavorite,
  });

  @override
  _JokeCategoryScreenState createState() => _JokeCategoryScreenState();
}

class _JokeCategoryScreenState extends State<JokeCategoryScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Map<String, dynamic>>> jokes;

  @override
  void initState() {
    super.initState();
    jokes = apiService.getJokesByType(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jokes: ${widget.type}'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: jokes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No jokes available'));
          } else {
            final jokes = snapshot.data!;
            return ListView.builder(
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                final joke = jokes[index];
                return JokeCard(
                  type: joke['type'],
                  setup: joke['setup'],
                  punchline: joke['punchline'],
                  onFavorite: () {
                    widget.addFavorite(joke['setup'], joke['punchline']);
                  },
                  isFavorite: widget.isFavorite(joke['setup'], joke['punchline']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
