import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_browsing_app/screens/home_screen.dart';
import 'package:movie_browsing_app/screens/login_screen.dart';
import 'package:movie_browsing_app/screens/verify_email_screen.dart';
import 'package:movie_browsing_app/theme_management/theme_manager.dart';
import 'theme_management/theme_enum.dart';
import 'firebase_options.dart';

final ThemePreferenceManager themeManager = ThemePreferenceManager();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  await dotenv.load(fileName: ".env");
  //print('Env loaded: ${dotenv.env['TMDB_API_KEY']}');


  final initialTheme = await themeManager.getTheme();

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

class AuthGate extends StatefulWidget {
  final ValueChanged<ThemeOption> onThemeChange;
  final ThemeOption currentTheme;

  const AuthGate({
    super.key,
    required this.onThemeChange,
    required this.currentTheme,
  });

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _userSub;
  User? _currentUser;
  bool _checkingVerification = true;

  @override
  void initState() {
    super.initState();


    _userSub = _auth.idTokenChanges().listen((user) async {
      _currentUser = user;
      if (user != null && !user.emailVerified) {

        _startVerificationChecker();
      }
      if (mounted) setState(() => _checkingVerification = false);
    });
  }

  void _startVerificationChecker() {
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _auth.currentUser?.reload();
      final refreshed = _auth.currentUser;
      if (refreshed != null && refreshed.emailVerified) {
        timer.cancel();
        await refreshed.getIdToken(true);
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _userSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingVerification) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = _currentUser;

    if (user == null) {
      return const LoginScreen();
    }

    if (!user.emailVerified) {
      return const VerifyEmailScreen();
    }

   return HomeScreen(
  currentTheme: widget.currentTheme,
  onThemeChange: widget.onThemeChange,
);

  }
}



