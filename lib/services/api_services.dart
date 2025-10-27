import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/movie.dart';

class ApiService {
  final String apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
  final String baseUrl = dotenv.env['TMDB_BASE_URL'] ?? 'https://api.themoviedb.org/3';


  Future<List<Movie>> _fetchMovies(String url) async {
    final uri = Uri.parse(url);
    int retries = 0;

    print('Fetching movies from $url');
    print("API Key: $apiKey");
    while (retries < 5) {
      try {
        final response = await http.get(uri).timeout(const Duration(seconds: 10));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final results = data['results'] as List? ?? [];
          return results
              .map((json) => Movie.fromJson(json))
              .where((m) => m.poster.isNotEmpty)
              .toList();
        } else {
          throw Exception('Failed to load: ${response.statusCode}');
        }
      } on SocketException catch (_) {
        retries++;
        await Future.delayed(const Duration(seconds: 2));
      } on TimeoutException catch (_) {
        retries++;
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    throw Exception('Network unstable or TMDb server timeout.');
  }



  Future<List<Movie>> fetchTopIndianMovies() async {
    final url =
        '$baseUrl/discover/movie?api_key=$apiKey&region=IN&with_original_language=hi&sort_by=popularity.desc&page=1';
    return _fetchMovies(url);
  }


  Future<List<Movie>> fetchPopularShows() async {
    final url =
        '$baseUrl/tv/popular?api_key=$apiKey&language=en-US&page=1';
    return _fetchMovies(url);
  }


  Future<List<Movie>> fetchGlobalPopularMovies() async {
    final url =
        '$baseUrl/movie/popular?api_key=$apiKey&language=en-US&page=1';
    return _fetchMovies(url);
  }


  Future<List<Movie>> searchMovies(String query) async {
    final url =
        '$baseUrl/search/movie?api_key=$apiKey&language=en-US&query=$query&page=1&include_adult=false';
    return _fetchMovies(url);
  }

  Future<Movie> getMovieDetails(String movieId) async {
    final url =
        '$baseUrl/movie/$movieId?api_key=$apiKey&language=en-US&append_to_response=credits,videos';
    final uri = Uri.parse(url);

    int retries = 0;

    while (retries < 5) {
      try {
        final response =
        await http.get(uri).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return Movie.fromDetailJson(data);
        } else {
          throw Exception('Failed to load movie details: ${response.statusCode}');
        }
      } on SocketException catch (_) {
        retries++;
        print('Retry $retries: SocketException');
        await Future.delayed(const Duration(seconds: 2));
      } on TimeoutException catch (_) {
        retries++;
        print('Retry $retries: Timeout');
        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        print('Unexpected error: $e');
        rethrow;
      }
    }
    throw Exception('Network unstable — please try again later.');
  }
}
