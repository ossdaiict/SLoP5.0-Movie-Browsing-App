import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_browsing_app/screens/favourite_screen.dart';
import 'package:movie_browsing_app/screens/settings_screen.dart';
import 'package:movie_browsing_app/services/api_services.dart';
import '../models/movie.dart';
import '../theme_management/theme_enum.dart';
import '../widgets/movie_card.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<ThemeOption> onThemeChange;
  final ThemeOption currentTheme;

  const HomeScreen({
    required this.onThemeChange,
    required this.currentTheme,
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget buildSection(String title, Future<List<Movie>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 250,
          child: FutureBuilder<List<Movie>>(
            future: items,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final movies = (snapshot.data ?? []).where((movie) {
                final p = movie.poster;
                return p.isNotEmpty && p != "N/A" && p.startsWith("http");
              }).toList();
              if (movies.isEmpty) {
                return const Center(child: Text('No movies found'));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return MovieCard(title: movie.title, movie: movie);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final topIndianMovies = apiService.fetchTopIndianMovies();
    final popularShows = apiService.fetchPopularShows();
    final globalPopularMovies = apiService.fetchGlobalPopularMovies();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.book_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavouritesScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    onThemeChange: widget.onThemeChange,
                    currentTheme: widget.currentTheme,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          buildSection('Top Indian Movies', topIndianMovies),
          buildSection('Popular Shows', popularShows),
          buildSection('Globally Popular Movies', globalPopularMovies),
        ],
      ),
    );
  }
}
