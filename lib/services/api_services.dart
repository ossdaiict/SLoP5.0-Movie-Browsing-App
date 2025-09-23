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
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  Future<Movie> getMovieDetails(String imdbID) async {
  
    throw UnimplementedError("getMovieDetails() not yet implemented.");
  }
}
