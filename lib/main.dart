// AFTER
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/services/service_locator.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Initialize services
    await _initializeServices();
    
    // Run app
    runApp(
      const ProviderScope(
        child: RideHailingApp(),
      ),
    );
  }, (error, stack) {
    // Print errors in debug mode
    debugPrint(error.toString());
    debugPrint(stack.toString());
    
    // In production, you could use a different error reporting service
    // For example, Sentry or custom Django backend error logging
  });
}

Future<void> _initializeServices() async {
  // Load environment variables
  await dotenv.load();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Register Hive adapters
  // TODO: Register your custom Hive adapters here
  
  // Initialize service locator
  await setupServiceLocator();
}