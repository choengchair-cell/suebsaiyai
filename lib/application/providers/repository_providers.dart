import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suebsaiyai/application/providers/datasource_providers.dart';
import 'package:suebsaiyai/data/repositories/auth_repository_impl.dart';
import 'package:suebsaiyai/data/repositories/district_repository_impl.dart';
import 'package:suebsaiyai/data/repositories/story_repository_impl.dart';
import 'package:suebsaiyai/domain/repositories/auth_repository.dart';
import 'package:suebsaiyai/domain/repositories/district_repository.dart';
import 'package:suebsaiyai/domain/repositories/story_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepositoryImpl(
      ref.watch(firebaseAuthDatasourceProvider),
      ref.watch(firestoreUserDatasourceProvider),
    ));

final storyRepositoryProvider = Provider<StoryRepository>((ref) => StoryRepositoryImpl(
      ref.watch(firestoreStoryDatasourceProvider),
    ));

final districtRepositoryProvider = Provider<DistrictRepository>((ref) => DistrictRepositoryImpl(
      ref.watch(firestoreDistrictDatasourceProvider),
    ));
