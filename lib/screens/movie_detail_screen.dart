import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  const MovieDetailScreen({super.key,required this.movie});

  @override
  Widget build(BuildContext context) {
    //final String movieId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: const Text("Movie Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 500,
              child: Image.network(
                movie.poster,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>  Container(padding:EdgeInsets.only(top:80,right:5,bottom:41,left:5),
                    child: const Center(child: Icon(Icons.broken_image, size: 40))),
              ),
            ),
            Text(
              movie.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              movie.year,
              style: TextStyle(color: Colors.grey,fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
