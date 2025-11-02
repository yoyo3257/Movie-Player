import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:movie_player/core/constant.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'movie_model.dart';

class MovieService {
  // ✅ Lazy getter instead of direct initialization
  Box get moviesBox => Hive.box('moviesBox');

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Constant.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  static const String _apiKey = Constant.apiKey;

  Future<List<Movie>> fetchMovies(int page) async {
    final cacheKey = 'page_$page';

    try {
      final response = await _dio.get(
        'movie/popular',
        queryParameters: {'api_key': _apiKey, 'page': page},
      );

      if (response.statusCode == 200) {
        final List results = response.data['results'];
        // ✅ Cache the data
        await moviesBox.put(cacheKey, results);
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Log to Sentry
      await Sentry.captureException(e);

      // Custom error handling
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection Timeout');
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception('Bad Response: ${e.response?.statusCode}');
      } else {
        throw Exception('Network Error: ${e.message}');
      }
    } catch (error, stackTrace) {
      // Log error to Sentry
      await Sentry.captureException(error, stackTrace: stackTrace);

      // ✅ Try to load from cache
      if (moviesBox.containsKey(cacheKey)) {
        final cachedData = moviesBox.get(cacheKey) as List;
        return cachedData
            .map((e) => Movie.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        rethrow; // No cache available
      }
    }
  }

  // ✅ Get all cached movies (for offline mode)
  Future<List<Movie>> getAllCachedMovies() async {
    final allMovies = <Movie>[];

    for (var key in moviesBox.keys) {
      if (key.toString().startsWith('page_')) {
        final cachedData = moviesBox.get(key) as List;
        final movies = cachedData
            .map((e) => Movie.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        allMovies.addAll(movies);
      }
    }

    return allMovies;
  }
}
