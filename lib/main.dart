import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suebsaiyai/app.dart';
import 'package:suebsaiyai/core/config/app_config.dart';

// Import generated firebase options — excluded from git, generated per environment.
// import 'package:suebsaiyai/core/config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize(AppEnvironment.development);

  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(child: SuebsaiyaiApp()),
  );
}
