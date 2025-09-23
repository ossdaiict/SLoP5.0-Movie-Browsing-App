import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:movie_browsing_app/screens/home_screen.dart';
import 'screens/movie_detail_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  runApp(const MovieBrowsingApp());
}


class MovieBrowsingApp extends StatelessWidget {
  const MovieBrowsingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Browsing App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      ),
      home: HomeScreen(), 
      routes: {
        '/movie-detail': (context) => MovieDetailScreen(),
      },
    );
  }
}
