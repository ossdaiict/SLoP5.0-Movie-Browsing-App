import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final subTextColor = textColor?.withOpacity(0.7);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.movie_rounded,
              size: 72,
            ),
            const SizedBox(height: 16),

            Text(
              'Movie Browsing App',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),

            Text(
              'Version 1.0.0',
              style: TextStyle(color: subTextColor),
            ),

            const SizedBox(height: 24),

            Text(
              'Discover trending movies, explore popular shows, and enjoy a personalized daily movie recommendation — all in one beautifully crafted app.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                height: 1.4,
              ),
            ),

            const Spacer(),

            const Divider(),

            const SizedBox(height: 12),

            Text(
              'This product uses the TMDB API but is not endorsed or certified by TMDB.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: subTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
