import 'package:dartz/dartz.dart';
import 'package:suebsaiyai/core/errors/failure.dart';
import 'package:suebsaiyai/domain/entities/story_entity.dart';
import 'package:suebsaiyai/domain/enums/story_status.dart';

abstract class StoryRepository {
  Stream<List<StoryEntity>> watchPublishedStories({String? districtId, List<String>? tags, int limit = 20});
  Stream<List<StoryEntity>> watchStoriesByAuthor(String authorId);
  Stream<List<StoryEntity>> watchStoriesByStatus(StoryStatus status);
  Future<Either<Failure, StoryEntity>> getStory(String id);
  Future<Either<Failure, StoryEntity>> createStory(StoryEntity story);
  Future<Either<Failure, StoryEntity>> updateStory(StoryEntity story);
  Future<Either<Failure, void>> deleteStory(String id);
  Future<Either<Failure, StoryEntity>> transitionStatus(String storyId, StoryStatus newStatus, {String? note});
  Future<Either<Failure, List<StoryEntity>>> searchStories(String query);
  Future<Either<Failure, List<StoryEntity>>> getStoriesByDistrict(String districtId, {int limit = 20, String? lastDocumentId});
}
