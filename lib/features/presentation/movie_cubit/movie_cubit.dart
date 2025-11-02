import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../data/movie_model.dart';
import '../../data/movie_services.dart';

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

      _currentPage++;
    } catch (e, st) {
      // Report error to Sentry
      await Sentry.captureException(e, stackTrace: st);

      // Try loading ALL cached movies from service
      try {
        final cachedMovies = await movieService.getAllCachedMovies();
        if (cachedMovies.isNotEmpty) {
          _movies = cachedMovies;
          emit(MovieLoaded(_movies, fromCache: true));
        } else {
          emit(MovieError(e.toString()));
        }
      } catch (_) {
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
}