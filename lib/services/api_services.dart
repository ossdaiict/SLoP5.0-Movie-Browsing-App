import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/movie.dart';

class ApiService {
  final String apiKey = dotenv.env['RAPIDAPI_KEY'] ?? '';
  final String apiHost = dotenv.env['RAPIDAPI_HOST'] ?? '';

  Future<List<Movie>> searchMovies(String query) async {
    final uri = Uri.https(
      apiHost,
      '/',
      {
        's': query,
        'r': 'json',
        'page': '1',
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'x-rapidapi-key': apiKey,
        'x-rapidapi-host': apiHost,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['Response'] == 'True') {
        final List moviesJson = data['Search'];
        List<Movie> movies=moviesJson.map((json) => Movie.fromJson(json)).toList();
        movies = movies.where((m) {
          final p = m.poster;
          return p.isNotEmpty && p != "N/A" && p.startsWith("http");
        }).toList();

        //movies.shuffle(Random());

        return movies;

      } else {
        return [];
      }
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  Future<List<Movie>> fetchTopIndianMovies() async {
    return searchMovies("Bollywood");
  }

  Future<List<Movie>> fetchPopularShows() async {
    final queries = ["Friends", "Stranger Things", "Breaking", "Money Heist"];
    queries.shuffle();
    final randomQuery = queries.first;
    return searchMovies(randomQuery);
  }

  Future<List<Movie>> fetchGlobalPopularMovies() async {
    final queries = ["Avengers", "Inception", "Batman", "Jurassic"];
    queries.shuffle();
    final randomQuery = queries.first;
    return searchMovies(randomQuery);
  }



  Future<Movie> getMovieDetails(String imdbID) async {
  
    throw UnimplementedError("getMovieDetails() not yet implemented.");
  }
}
