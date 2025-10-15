import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie.dart';

class FavouritesService {
  final _firestore = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser;


  Future<void> addToFavourites(Movie movie) async {
    if (_user == null) return;
    final docRef = _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('favourites')
        .doc(movie.imdbID);

    await docRef.set({
      'Title': movie.title,
      'Year': movie.year,
      'Poster': movie.poster,
      'imdbID': movie.imdbID,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }


  Future<void> removeFromFavourites(String imdbID) async {
    if (_user == null) return;
    await _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('favourites')
        .doc(imdbID)
        .delete();
  }


  Future<bool> isFavourite(String imdbID) async {
    if (_user == null) return false;
    final doc = await _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('favourites')
        .doc(imdbID)
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
        title: data['Title'] ?? '',
        year: data['Year'] ?? '',
        imdbID: data['imdbID'] ?? '',
        poster: data['Poster'] ?? '',
      );
    }).toList());
  }
}
