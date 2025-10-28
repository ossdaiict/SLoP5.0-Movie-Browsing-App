import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_browsing_app/screens/favourite_screen.dart';
import 'package:movie_browsing_app/screens/movie_detail_screen.dart';
import 'package:movie_browsing_app/screens/profile_screen.dart';
import 'package:movie_browsing_app/screens/settings_screen.dart';
import 'package:movie_browsing_app/services/api_services.dart';
import '../models/movie.dart';
import '../theme_management/theme_enum.dart';
import '../widgets/movie_card.dart';
import 'search_screen.dart' hide Movie;

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




  late ApiService apiService;
  late Future<List<Movie>> topIndianMovies;
  late Future<List<Movie>> popularShows;
  late Future<List<Movie>> globalPopularMovies;

  void _loadData() {
    setState(() {
      topIndianMovies = apiService.fetchTopIndianMovies();
      popularShows = apiService.fetchPopularShows();
      globalPopularMovies = apiService.fetchGlobalPopularMovies();
    });
  }

  int _selectedIndex = 0;
  late List<Widget> _tabs;


  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _loadData();
    _tabs = [
      HomeScreen(
        onThemeChange: widget.onThemeChange,
        currentTheme: widget.currentTheme,
      ),
      const FavouritesScreen(),
      const ProfileScreen(),
    ];


  }


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
                  return InkWell(
                    onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: movie)));
                    },
                      child: MovieCard(movie: movie));
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
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
          await Future.delayed(const Duration(seconds: 2));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Movies refreshed')),
          );
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            buildSection('Top Indian Movies', topIndianMovies),
            buildSection('Popular Shows', popularShows),
            buildSection('Globally Popular Movies', globalPopularMovies),
          ],
        ),
      ),


    );
  }
}


class MainNavigation extends StatefulWidget {
  final ThemeOption currentTheme;
  final ValueChanged<ThemeOption> onThemeChange;

  const MainNavigation({
    super.key,
    required this.currentTheme,
    required this.onThemeChange,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      HomeScreen(
        currentTheme: widget.currentTheme,
        onThemeChange: widget.onThemeChange,
      ),
      const FavouritesScreen(),
      const ProfileScreen(),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap:(index)=>{
              setState(() {
                _selectedIndex = index;
              })
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourites'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ] ));
}

}