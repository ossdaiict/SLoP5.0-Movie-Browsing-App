import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie.dart';

class FavouritesService {
  final _firestore = FirebaseFirestore.instance;
  User? get _user => FirebaseAuth.instance.currentUser;


  Future<void> addToFavourites(Movie movie) async {
    if (_user == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('favourites')
        .doc(movie.id.toString());

    await docRef.set({
      'id': movie.id,
      'title': movie.title,
      'poster': movie.poster,
      'releaseDate': movie.releaseDate,
      'rating': movie.rating,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }


  Future<void> removeFromFavourites(String movieId) async {
    if (_user == null) return;
    await _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('favourites')
        .doc(movieId)
        .delete();
  }


  Future<bool> isFavourite(String movieId) async {
    if (_user == null) return false;
    final doc = await _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('favourites')
        .doc(movieId)
        .get();
    return doc.exists;
  }

  Stream<List<Movie>> getFavourites() {
    if (_user == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('favourites')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      return Movie(
        id: data['id'] ?? 0,
        title: data['title'] ?? '',
        overview: '',
        releaseDate: data['releaseDate'] ?? '',
        poster: data['poster'] ?? '',
        backdrop: '',
        rating: (data['rating'] ?? 0).toDouble(),
        genres: [],
        runtime: 0,
        language: '',
        cast: [],
      );
    }).toList());
  }
}
