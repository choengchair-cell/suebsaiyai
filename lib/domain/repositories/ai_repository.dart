import 'package:dartz/dartz.dart';
import 'package:suebsaiyai/core/errors/failure.dart';
import 'package:suebsaiyai/domain/entities/ai_artifact_entity.dart';
import 'package:suebsaiyai/domain/enums/ai_artifact_type.dart';

abstract class AiRepository {
  Future<Either<Failure, AiArtifactEntity>> generateArtifact({
    required String storyId,
    required String storyContent,
    required AiArtifactType type,
  });
  Future<Either<Failure, List<AiArtifactEntity>>> getArtifactsForStory(String storyId);
  Future<Either<Failure, AiArtifactEntity>> validateArtifact(String artifactId, String validatorId);
  Future<Either<Failure, List<String>>> suggestTags(String content);
  Future<Either<Failure, String>> generateSummary(String content);
}
