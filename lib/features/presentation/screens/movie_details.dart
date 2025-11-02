import 'package:flutter/material.dart';
import '../../data/movie_model.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details'),
        backgroundColor: isDark
            ? Colors.grey.shade900
            : Colors.blueAccent.shade100,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            // Movie poster
            Center(
              child: Image.network(
                'https://image.tmdb.org/t/p/w154${movie.posterPath}',
                height: 300,
                width: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            // Title and date
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                movie.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Rating
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    '${movie.voteAverage.toStringAsFixed(1)} / 10',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Description',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            // Overview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                movie.overview.isNotEmpty
                    ? movie.overview
                    : "No overview available.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
