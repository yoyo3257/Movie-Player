import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:movie_player/core/constant.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'movie_model.dart';

class MovieService {
  final Box moviesBox = Hive.box('moviesBox');
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
        await moviesBox.put(cacheKey, results);
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // custom error handling
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

      // If there's cached data, use it
      if (moviesBox.containsKey(cacheKey)) {
        final cachedData = moviesBox.get(cacheKey) as List;
        return cachedData
            .map((e) => Movie.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        rethrow; // no cache, throw the error
      }
    }
  }
}
