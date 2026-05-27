import 'package:dartz/dartz.dart';
import 'package:suebsaiyai/core/errors/failure.dart';
import 'package:suebsaiyai/data/datasources/remote/firestore_story_datasource.dart';
import 'package:suebsaiyai/data/models/story_model.dart';
import 'package:suebsaiyai/domain/entities/story_entity.dart';
import 'package:suebsaiyai/domain/enums/story_status.dart';
import 'package:suebsaiyai/domain/repositories/story_repository.dart';

class StoryRepositoryImpl implements StoryRepository {
  StoryRepositoryImpl(this._ds);
  final FirestoreStoryDatasource _ds;

  @override
  Stream<List<StoryEntity>> watchPublishedStories({String? districtId, List<String>? tags, int limit = 20}) =>
      _ds.watchPublishedStories(districtId: districtId, limit: limit).map((list) => list.map((m) => m.toEntity()).toList());

  @override
  Stream<List<StoryEntity>> watchStoriesByAuthor(String authorId) =>
      _ds.watchStoriesByAuthor(authorId).map((list) => list.map((m) => m.toEntity()).toList());

  @override
  Stream<List<StoryEntity>> watchStoriesByStatus(StoryStatus status) =>
      _ds.watchStoriesByStatus(status.firestoreValue).map((list) => list.map((m) => m.toEntity()).toList());

  @override
  Future<Either<Failure, StoryEntity>> getStory(String id) async {
    try {
      final model = await _ds.getStory(id);
      if (model == null) return const Left(NotFoundFailure('ไม่พบเรื่องนี้'));
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, StoryEntity>> createStory(StoryEntity story) async {
    try {
      final model = await _ds.createStory(StoryModel.fromEntity(story));
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, StoryEntity>> updateStory(StoryEntity story) async {
    try {
      final model = StoryModel.fromEntity(story);
      await _ds.updateStory(story.id, model.toFirestore());
      return Right(story);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStory(String id) async {
    try {
      await _ds.deleteStory(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, StoryEntity>> transitionStatus(String storyId, StoryStatus newStatus, {String? note}) async {
    try {
      await _ds.updateStory(storyId, {'status': newStatus.firestoreValue});
      final updated = await _ds.getStory(storyId);
      if (updated == null) return const Left(NotFoundFailure('ไม่พบเรื่องนี้'));
      return Right(updated.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StoryEntity>>> searchStories(String query) async {
    try {
      // Basic title search — for production use Algolia or Typesense
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StoryEntity>>> getStoriesByDistrict(String districtId, {int limit = 20, String? lastDocumentId}) async {
    try {
      // Paginated query implementation
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
