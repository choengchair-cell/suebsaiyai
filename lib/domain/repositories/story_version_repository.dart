import 'package:dartz/dartz.dart';
import 'package:suebsaiyai/core/errors/failure.dart';
import 'package:suebsaiyai/domain/entities/story_version_entity.dart';

abstract class StoryVersionRepository {
  Future<Either<Failure, StoryVersionEntity>> createVersion(StoryVersionEntity version);
  Future<Either<Failure, List<StoryVersionEntity>>> getVersionsForStory(String storyId);
  Future<Either<Failure, StoryVersionEntity>> getVersion(String versionId);
}
