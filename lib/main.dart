import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_browsing_app/screens/home_screen.dart';
import 'package:movie_browsing_app/screens/login_screen.dart';
import 'package:movie_browsing_app/screens/signup_screen.dart';
import 'package:movie_browsing_app/screens/movie_detail_screen.dart';
import 'package:movie_browsing_app/theme_management/theme_manager.dart';
import 'theme_management/theme_enum.dart';
import 'firebase_options.dart';

final ThemePreferenceManager themeManager = ThemePreferenceManager();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Read the persisted theme before running the app
  final initialTheme = await themeManager.getTheme();

  // Pass the initial theme to the app
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
    _currentThemeOption = widget.initialTheme;
  }

  void setThemeOption(ThemeOption option) {
    setState(() {
      _currentThemeOption = option;
    });
    themeManager.saveTheme(option);
  }

  ThemeOption get currentTheme => _currentThemeOption;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Browsing App',

      // LIGHT THEME
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

      // DARK THEME
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      ),

      themeMode: getThemeMode(_currentThemeOption),

      // AuthGate decides whether to show Login or Home
      home: AuthGate(
        onThemeChange: setThemeOption,
        currentTheme: currentTheme,
      ),
      // routes: {
      //   '/movie-detail': (context) => const MovieDetailScreen(movie: ,),
      // },
    );
  }
}

class AuthGate extends StatelessWidget {
  final ValueChanged<ThemeOption> onThemeChange;
  final ThemeOption currentTheme;

  const AuthGate({
    super.key,
    required this.onThemeChange,
    required this.currentTheme,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasData) {
          return HomeScreen(
            onThemeChange: onThemeChange,
            currentTheme: currentTheme,
          );
        }
        return const LoginScreen();
      },
    );
  }
}
