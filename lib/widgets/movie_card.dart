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
  final Set<String> wishlist = {};

  @override
  Widget build(BuildContext context) {
    Future<void> toggleFavourite(Movie movie) async {
      final isFav = wishlist.contains(movie.imdbID);
      setState(() {
        if (isFav) {
          wishlist.remove(movie.imdbID);
        } else {
          wishlist.add(movie.imdbID);
        }
      });
      if (isFav) {
        await favService.removeFromFavourites(movie.imdbID);
      } else {
        await favService.addToFavourites(movie);
      }
    }

    final poster = widget.movie.poster;

    final isLiked = wishlist.contains(widget.movie.imdbID);
    return Container(
      width: 100,
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(1),
                child: Image.network(
                  poster,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                  width: 120,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                //textAlign: TextAlign.center,
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
              top:0,
              child:  GestureDetector(
                child: Icon(
                  isLiked?Icons.bookmark_added:Icons.bookmark_add_outlined,
                  color:isLiked?Colors.blueAccent :Colors.white ,
                  size: 25,
                ),
                onTap: () {
                  toggleFavourite(widget.movie);
                  /*setState(() {
                if (isLiked) {
                  wishlist.remove(movie.imdbID);
                } else {
                  wishlist.add(movie.imdbID);
                }
              });*/
                },
              )),
        ],
      ),
    );
  }
}

