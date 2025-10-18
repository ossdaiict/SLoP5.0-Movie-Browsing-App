import 'package:flutter/material.dart';
import 'package:movie_browsing_app/screens/settings_screen.dart';
import '../theme_management/theme_enum.dart';
import '../widgets/movie_card.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<ThemeOption> onThemeChange;
  final ThemeOption currentTheme;

  const HomeScreen({
    required this.onThemeChange,
    required this.currentTheme,
    super.key});

  @override
  Widget build(BuildContext context) {
    final topIndianMovies = ['Movie A', 'Movie B', 'Movie C'];
    final popularShows = ['Show 1', 'Show 2', 'Show 3'];
    final globalPopularMovies = ['Global 1', 'Global 2', 'Global 3'];

    Widget buildSection(String title, List<String> items) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child:
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold , color: Theme.of(context).textTheme.bodyLarge?.color, ),),
          ),
          SizedBox(
            height: 150,
            child: ListView.separated(

              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 8),
              itemCount: items.length,
              separatorBuilder: (_, __) => SizedBox(width: 10),
              itemBuilder: (_, index) => MovieCard(title: items[index]),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),

        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    // Passed the required theme control callbacks and state
                    onThemeChange: onThemeChange,
                    currentTheme: currentTheme,
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
