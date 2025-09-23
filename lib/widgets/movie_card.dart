import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String title;

  const MovieCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      color: Colors.grey[300],
      child: Center(
          child: Text(
        title,
        textAlign: TextAlign.center,
      )),
    );
  }
}
