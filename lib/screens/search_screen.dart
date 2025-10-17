import "package:flutter/material.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Movie {
  final String imdbID;
  final String title;
  final String posterUrl;

  Movie({required this.imdbID, required this.title, required this.posterUrl});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbID: json['imdbID'] as String? ?? 'N/A',
      title: json['Title'] as String? ?? 'Untitled',
      posterUrl: json['Poster'] as String? ?? 'N/A',
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  Timer? _debounce;
  final Duration _debounceDuration = const Duration(milliseconds: 500);

  final String _apiKey = dotenv.env['OMDB_API_KEY'] ?? 'YOUR_OMDB_API_KEY_ERROR';
  final String _baseUrl = 'https://www.omdbapi.com/';


  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _error = null;
        _isLoading = false;
      });
      _debounce?.cancel();
      return;
    }

    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    setState(() => _isLoading = true);

    _debounce = Timer(_debounceDuration, () {
      if (query.length > 2) {
        _fetchMovies(query);
      } else {
        setState(() {
          _searchResults = [];
          _isLoading = false;
        });
      }
    });
  }

  // API Call Function
  Future<void> _fetchMovies(String query) async {
    if (_isLoading && _debounce?.isActive == false) {
      setState(() => _isLoading = true);
    }

    final encodedQuery = Uri.encodeComponent(query);
    final url = '$_baseUrl?s=$encodedQuery&apikey=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['Response'] == 'True') {
          final List<dynamic> results = data['Search'] ?? [];

          setState(() {
            _searchResults = results.map((json) => Movie.fromJson(json)).toList();
            _error = null;
            _isLoading = false;
          });
        } else {
          setState(() {
            _searchResults = [];
            _error = null;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Failed to load results. Status Code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network Error: Could not connect to the API.';
        _isLoading = false;
      });
    }
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error: $_error',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_searchResults.isEmpty && _searchController.text.length > 2) {
      return const Center(
        child: Text(
          'No results found for your query.',
          style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
        ),
      );
    }

    if (_searchResults.isEmpty && _searchController.text.isEmpty) {
      return const Center(
        child: Text(
          'Start typing to search for movies.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    // Display results in a grid
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.45,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final movie = _searchResults[index];
        final isPosterAvailable = movie.posterUrl != 'N/A';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: isPosterAvailable
                    ? Image.network(
                  movie.posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image, size: 40)),
                )
                    : const Center(child: Icon(Icons.movie_filter, size: 60)),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 35, // Guarantees space for two lines of text
              child: Text(
                movie.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search movies...',
            hintStyle: const TextStyle(color: Colors.white70),
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            )
                : null,
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: _buildBody(),
    );
  }
}