class Movie {
  final int id;
  final String title;
  final String overview;
  final String releaseDate;
  final String poster;
  final String backdrop;
  final double rating;
  final List<String> genres;
  final int runtime;
  final String language;
  final List<String> cast;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.poster,
    required this.backdrop,
    required this.rating,
    required this.genres,
    required this.runtime,
    required this.language,
    required this.cast,
  });

  static const Map<int, String> _genreMap = {
    28: 'Action',
    12: 'Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    14: 'Fantasy',
    36: 'History',
    27: 'Horror',
    10402: 'Music',
    9648: 'Mystery',
    10749: 'Romance',
    878: 'Science Fiction',
    10770: 'TV Movie',
    53: 'Thriller',
    10752: 'War',
    37: 'Western'
  };

  factory Movie.fromJson(Map<String, dynamic> json) {

    final ids = (json['genre_ids'] as List?)?.cast<int>() ?? [];
    final genreNames = ids.map((id) => _genreMap[id]).whereType<String>().toList();
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? 'Untitled',
      overview: json['overview'] ?? '',
      releaseDate: json['release_date'] ?? '',
      poster: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : '',
      backdrop: json['backdrop_path'] != null
          ? 'https://image.tmdb.org/t/p/w780${json['backdrop_path']}'
          : '',
      rating: (json['vote_average'] ?? 0).toDouble(),
      genres: genreNames,
      runtime: 0,
      language: json['original_language'] ?? '',
      cast: [],
    );
  }

  factory Movie.fromDetailJson(Map<String, dynamic> json) {
    final genres = (json['genres'] as List?)
        ?.map((g) => g['name'] as String)
        .toList() ??
        [];
    final cast = (json['credits']?['cast'] as List?)
        ?.take(10)
        .map((c) => c['name'] as String)
        .toList() ??
        [];

    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? 'Untitled',
      overview: json['overview'] ?? '',
      releaseDate: json['release_date'] ?? '',
      poster: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : '',
      backdrop: json['backdrop_path'] != null
          ? 'https://image.tmdb.org/t/p/original${json['backdrop_path']}'
          : '',
      rating: (json['vote_average'] ?? 0).toDouble(),
      genres: genres,
      runtime: json['runtime'] ?? 0,
      language: json['original_language'] ?? '',
      cast: cast,
    );
  }
}
