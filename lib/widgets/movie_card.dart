import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/favourites_service.dart';

class MovieCard extends StatefulWidget {
  final String title;
  final Movie movie;
  const MovieCard({super.key, required this.title, required this.movie});

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
    final exists = await favService.isFavourite(widget.movie.imdbID);
    if (mounted) {
      setState(() => isLiked = exists);
    }
  }

  Future<void> toggleFavourite(Movie movie) async {
    if (isLiked) {
      await favService.removeFromFavourites(movie.imdbID);
    } else {
      await favService.addToFavourites(movie);
    }
    setState(() => isLiked = !isLiked);
  }

  @override
  Widget build(BuildContext context) {
    final poster = widget.movie.poster;

    return Container(
      width: 120,
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  poster,
                  width: 120,
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>  Container(padding:EdgeInsets.only(top:80,right:5,bottom:41,left:5),
                      child: const Center(child: Icon(Icons.broken_image, size: 40))),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                widget.movie.year,
                style: const TextStyle(fontSize: 12, color: Colors.grey),

              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () => toggleFavourite(widget.movie),
              child: Icon(
                isLiked ? Icons.bookmark_added : Icons.bookmark_add_outlined,
                color: isLiked ? Colors.blueAccent : Colors.white,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
