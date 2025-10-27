import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/favourites_service.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  final favService = FavouritesService();
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavourite();
  }

  Future<void> _checkIfFavourite() async {
    final exists = await favService.isFavourite(widget.movie.id.toString());
    if (mounted) setState(() => isLiked = exists);
  }

  Future<void> toggleFavourite() async {
    if (isLiked) {
      await favService.removeFromFavourites(widget.movie.id.toString());
    } else {
      await favService.addToFavourites(widget.movie);
    }
    setState(() => isLiked = !isLiked);
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final genres = movie.genres.isNotEmpty ? movie.genres.join(', ') : 'N/A';
    return Container(
      width: 130,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  movie.poster,
                  height: 180,
                  width: 130,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                movie.releaseDate.isNotEmpty
                    ? movie.releaseDate.split('-').first
                    : '-',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                movie.genres.isNotEmpty ? movie.genres.first : 'Unknown',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),

            ],
          ),
          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
              onTap: toggleFavourite,
              child: Icon(
                isLiked
                    ? Icons.bookmark_added
                    : Icons.bookmark_add_outlined,
                color: isLiked ? Colors.blueAccent : Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
