import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../movie_cubit/movie_cubit.dart';
import '../theme_cubit/theme_cubit.dart';
import 'movie_details.dart';

class MovieList2 extends StatefulWidget {
  const MovieList2({super.key, required ScrollController scrollController})
    : _scrollController = scrollController;

  final ScrollController _scrollController;

  @override
  State<MovieList2> createState() => _MovieList2State();
}

class _MovieList2State extends State<MovieList2> {
  @override
  void initState() {
    super.initState();

    widget._scrollController.addListener(() {
      if (widget._scrollController.position.pixels >=
          widget._scrollController.position.maxScrollExtent - 200) {
        // Trigger next page
        context.read<MovieCubit>().fetchMovies(loadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark; // ✅ dynamic

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("🎬 Movies")),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.wb_sunny : Icons.dark_mode),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
        ],
      ),
      body: BlocBuilder<MovieCubit, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading && state is! MovieLoaded) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieLoaded || state is MovieLoadingMore) {
            final movies = state is MovieLoaded
                ? state.movies
                : (state as MovieLoadingMore).oldMovies;
            return RefreshIndicator(
              onRefresh: () async {
              context.read<MovieCubit>().refreshMovies();
            },
              child: ListView.builder(
                controller: widget._scrollController,
                itemCount: movies.length + 1,
                itemBuilder: (context, index) {
                  if (index < movies.length) {
                    final movie = movies[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w154${movie.posterPath}',
                              height: 120,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    movie.releaseDate,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        movie.voteAverage.toStringAsFixed(1),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MovieDetailsPage(movie: movie),
                                ),
                              );
                            },
                            icon: const Icon(Icons.navigate_next_rounded),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            );
          } else if (state is MovieError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.read<MovieCubit>().fetchMovies(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
