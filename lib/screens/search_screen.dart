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
  bool isGridView = true; // Toggle state

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

    _debounce?.cancel();
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

  Future<void> _fetchMovies(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url = '$_baseUrl?s=$encodedQuery&apikey=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['Response'] == 'True') {
          final List<dynamic> results = data['Search'] ?? [];
          setState(() {
            _searchResults =
                results.map((json) => Movie.fromJson(json)).toList();
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
          _error =
              'Failed to load results. Status Code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (_) {
      setState(() {
        _error = 'Network error. Please try again later.';
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
          padding: const EdgeInsets.all(16),
          child: Text(
            '⚠️ $_error',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_searchResults.isEmpty && _searchController.text.length > 2) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 60, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                '🎬 No movies found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Try another title or check your spelling ✨',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_searchResults.isEmpty && _searchController.text.isEmpty) {
      return const Center(
        child: Text(
          '🍿 Start typing to search for movies',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: isGridView
          ? GridView.builder(
              key: const ValueKey('gridView'),
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.45,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final movie = _searchResults[index];
                final hasPoster = movie.posterUrl != 'N/A';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: hasPoster
                            ? Image.network(
                                movie.posterUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.broken_image, size: 40),
                              )
                            : const Icon(Icons.movie_filter, size: 60),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 35,
                      child: Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          : ListView.builder(
              key: const ValueKey('listView'),
              padding: const EdgeInsets.all(8),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final movie = _searchResults[index];
                final hasPoster = movie.posterUrl != 'N/A';

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  height: 140,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: hasPoster
                            ? Image.network(
                                movie.posterUrl,
                                width: 100,
                                height: 140,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.broken_image, size: 40),
                              )
                            : const Icon(Icons.movie_filter, size: 60),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          movie.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
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
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
}
