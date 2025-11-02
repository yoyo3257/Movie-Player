import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_player/features/presentation/screens/movie_list_page.dart';
import 'features/data/movie_services.dart';
import 'features/presentation/movie_cubit/movie_cubit.dart';
import 'features/presentation/theme_cubit/theme_cubit.dart';
import '../../../core/themes/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive
  final appDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDir.path);
  await Hive.openBox('moviesBox'); // simple key-value cache
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://401dda4130c07c6d8cfd1b5f6a689238@o4510294321332224.ingest.us.sentry.io/4510294322315264';
      options.tracesSampleRate = 1.0; // capture performance traces
    },
    appRunner: () => runApp(
      BlocProvider(create: (_) => ThemeCubit(), child: const HomeScreen()),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => MovieCubit(MovieService())..fetchMovies(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Movie Player',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode, // 👈 Works dynamically now
            home: MovieList2(scrollController: _scrollController),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
