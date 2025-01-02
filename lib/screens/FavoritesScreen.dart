import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Map<String, String>> favoriteJokes;
  final Function(String, String) removeFavorite;

  const FavoritesScreen({
    Key? key,
    required this.favoriteJokes,
    required this.removeFavorite,
  }) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorite Jokes")),
      body: widget.favoriteJokes.isEmpty
          ? Center(child: Text("No favorites added yet."))
          : ListView.builder(
        itemCount: widget.favoriteJokes.length,
        itemBuilder: (context, index) {
          final joke = widget.favoriteJokes[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          joke['setup']!,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          joke['punchline']!,
                          style: TextStyle(
                              fontSize: 14, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      widget.removeFavorite(joke['setup']!, joke['punchline']!);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
