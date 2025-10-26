import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/theme/color_scheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // TODO: Initialize Supabase
  // await Supabase.initialize(
  //   url: 'your-supabase-url',
  //   anonKey: 'your-supabase-anon-key',
  // );

  // TODO: Initialize error reporting
  // await SentryFlutter.init(
  //   (options) {
  //     options.dsn = 'your-sentry-dsn';
  //   },
  //   appRunner: () => runApp(const ProviderScope(child: PennyPalApp())),
  // );

  runApp(
    const ProviderScope(
      child: PennyPalApp(),
    ),
  );
}