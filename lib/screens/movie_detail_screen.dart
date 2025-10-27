import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_services.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final api = ApiService();

    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: FutureBuilder<Movie>(
        future: api.getMovieDetails(movie.id.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString().contains('Network unstable')
                    ? 'Network unstable. Please retry.'
                    : 'Error: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final detailed = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (detailed.poster.isNotEmpty)
                  Image.network(
                    detailed.poster,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 40),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${detailed.title} (${detailed.releaseDate.split('-').first})',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),

                      Text(
                        '⭐ ${detailed.rating.toStringAsFixed(1)}   •   ${detailed.language.toUpperCase()}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.amber),
                      ),
                      const SizedBox(height: 10),
                      if (detailed.genres.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          children: detailed.genres
                              .map((g) => Chip(label: Text(g)))
                              .toList(),
                        ),
                      const Divider(height: 24),

                      const Text(
                        'Overview',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        detailed.overview.isNotEmpty
                            ? detailed.overview
                            : 'No overview available.',
                        style: const TextStyle(fontSize: 15, height: 1.4),
                      ),

                      const Divider(height: 24),

                      // Cast section
                      if (detailed.cast.isNotEmpty) ...[
                        const Text(
                          'Cast',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: detailed.cast
                              .map((c) => Chip(label: Text(c)))
                              .toList(),
                        ),
                      ],

                      const Divider(height: 24),
                      Text('Runtime: ${detailed.runtime} min',
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
