import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:movie_browsing_app/screens/home_screen.dart';
import 'package:movie_browsing_app/theme_management/theme_manager.dart';
import 'screens/movie_detail_screen.dart';
import 'theme_management/theme_enum.dart';
final ThemePreferenceManager themeManager = ThemePreferenceManager();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Read the persisted theme before running the app
  final initialTheme = await themeManager.getTheme();

  // Pass the initial theme to the stateful widget constructor
  runApp(MovieBrowsingApp(initialTheme: initialTheme));
}

class MovieBrowsingApp extends StatefulWidget {
  final ThemeOption initialTheme;

  const MovieBrowsingApp({required this.initialTheme, super.key});

  @override
  State<MovieBrowsingApp> createState() => _MovieBrowsingAppState();
}

class _MovieBrowsingAppState extends State<MovieBrowsingApp> {
  late ThemeOption _currentThemeOption;

  @override
  void initState() {
    super.initState();
    // Initialize the state with the persisted value
    _currentThemeOption = widget.initialTheme;
  }

  // State Update Function
  void setThemeOption(ThemeOption option) {
    setState(() {
      _currentThemeOption = option;
    });
    themeManager.saveTheme(option);
  }

  // Getter for the current theme option
  ThemeOption get currentTheme => _currentThemeOption;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Browsing App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      ),

      // 2. DARK THEME Definition
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
        // This explicitly overrides the dark theme defaults for the AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      ),

      themeMode: getThemeMode(_currentThemeOption),

      // Passed the setter and getter down to HomeScreen
      home: HomeScreen(
        onThemeChange: setThemeOption,
        currentTheme: currentTheme,
      ),

      routes: {
        '/movie-detail': (context) => const MovieDetailScreen(),
      },
    );
  }
}