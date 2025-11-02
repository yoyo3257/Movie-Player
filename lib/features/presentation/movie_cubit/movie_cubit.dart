// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../data/movie_model.dart';
// import '../../data/movie_services.dart';
//
//
// part 'movie_state.dart';
//
// class MovieCubit extends Cubit<MovieState> {
//   final MovieService movieService;
//
//   MovieCubit(this.movieService) : super(MovieInitial());
//
//   int _currentPage = 1;
//   bool _isLoading = false;
//   List<Movie> _movies = [];
//
//   Future<void> fetchMovies({bool loadMore = false}) async {
//     if (_isLoading) return;
//
//     _isLoading = true;
//     if (!loadMore) emit(MovieLoading());
//
//     try {
//       final newMovies = await movieService.fetchMovies(_currentPage);
//       _movies = [..._movies, ...newMovies];
//       emit(MovieLoaded(_movies));
//
//       _currentPage++;
//     } catch (e) {
//       emit(MovieError(e.toString()));
//     } finally {
//       _isLoading = false;
//     }
//   }
//
//   void refreshMovies() {
//     _movies.clear();
//     _currentPage = 1;
//     fetchMovies();
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/movie_model.dart';
import '../../data/movie_services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:hive/hive.dart';

part 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieService movieService;

  MovieCubit(this.movieService) : super(MovieInitial());

  int _currentPage = 1;
  bool _isLoading = false;
  List<Movie> _movies = [];

  Future<void> fetchMovies({bool loadMore = false}) async {
    if (_isLoading) return;
    _isLoading = true;

    if (!loadMore) {
      emit(MovieLoading());
    } else {
      emit(MovieLoadingMore(_movies));
    }

    try {
      // Fetch movies from API
      final newMovies = await movieService.fetchMovies(_currentPage);
      _movies = [..._movies, ...newMovies];
      emit(MovieLoaded(_movies));

      // Cache new movies locally
      await _cacheMovies(_movies);

      _currentPage++;
    } catch (e, st) {
      // ✅ Report error to Sentry
      await Sentry.captureException(e, stackTrace: st);

      // Try loading from cache if available
      final cached = await _loadCachedMovies();
      if (cached.isNotEmpty) {
        emit(MovieLoaded(cached, fromCache: true));
      } else {
        emit(MovieError(e.toString()));
      }
    } finally {
      _isLoading = false;
    }
  }

  void refreshMovies() {
    _movies.clear();
    _currentPage = 1;
    fetchMovies();
  }

  // 🔹 Cache movies using Hive
  Future<void> _cacheMovies(List<Movie> movies) async {
    final box = await Hive.openBox('moviesBox');
    await box.put('movies', movies.map((m) => m.toJson()).toList());
  }

  // 🔹 Load cached movies
  Future<List<Movie>> _loadCachedMovies() async {
    final box = await Hive.openBox('moviesBox');
    final cachedData = box.get('movies', defaultValue: []);
    return (cachedData as List)
        .map((item) => Movie.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
