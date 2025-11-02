// part of 'movie_cubit.dart';
//
// abstract class MovieState {}
//
// class MovieInitial extends MovieState {}
//
// class MovieLoading extends MovieState {}
//
// class MovieLoaded extends MovieState {
//   final List<Movie> movies;
//   MovieLoaded(this.movies);
// }
//
// class MovieError extends MovieState {
//   final String message;
//   MovieError(this.message);
// }
part of 'movie_cubit.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoadingMore extends MovieState {
  final List<Movie> oldMovies;
  MovieLoadingMore(this.oldMovies);
}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final bool fromCache;

  MovieLoaded(this.movies, {this.fromCache = false});
}

class MovieError extends MovieState {
  final String message;
  MovieError(this.message);
}
