import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suebsaiyai/application/providers/firebase_providers.dart';
import 'package:suebsaiyai/data/datasources/remote/claude_ai_datasource.dart';
import 'package:suebsaiyai/data/datasources/remote/firebase_auth_datasource.dart';
import 'package:suebsaiyai/data/datasources/remote/firestore_district_datasource.dart';
import 'package:suebsaiyai/data/datasources/remote/firestore_story_datasource.dart';
import 'package:suebsaiyai/data/datasources/remote/firestore_user_datasource.dart';

final firebaseAuthDatasourceProvider = Provider((ref) => FirebaseAuthDatasource(ref.watch(firebaseAuthProvider)));

final firestoreStoryDatasourceProvider = Provider((ref) => FirestoreStoryDatasource(ref.watch(firestoreProvider)));

final firestoreUserDatasourceProvider = Provider((ref) => FirestoreUserDatasource(ref.watch(firestoreProvider)));

final firestoreDistrictDatasourceProvider = Provider((ref) => FirestoreDistrictDatasource(ref.watch(firestoreProvider)));

final dioProvider = Provider((ref) => Dio());

// NOTE: In production, load API key from secure environment config, never hardcode.
final claudeAiDatasourceProvider = Provider((ref) => ClaudeAiDatasource(
      ref.watch(dioProvider),
      const String.fromEnvironment('CLAUDE_API_KEY', defaultValue: ''),
    ));
