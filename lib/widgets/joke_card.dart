import 'package:flutter/material.dart';

class JokeCard extends StatelessWidget {
  final String type;
  final String setup;
  final String punchline;
  final Function onFavorite;
  final bool isFavorite;

  JokeCard({
    required this.type,
    required this.setup,
    required this.punchline,
    required this.onFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(setup),
        subtitle: Text(punchline),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            onFavorite();
          },
        ),
      ),
    );
  }
}
