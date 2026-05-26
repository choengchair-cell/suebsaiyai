import 'package:dartz/dartz.dart';
import 'package:suebsaiyai/core/errors/failure.dart';
import 'package:suebsaiyai/domain/entities/media_entity.dart';
import 'package:suebsaiyai/domain/enums/media_type.dart';

abstract class MediaRepository {
  Future<Either<Failure, MediaEntity>> uploadMedia({
    required String storyId,
    required List<int> bytes,
    required String fileName,
    required MediaType type,
    String? caption,
  });
  Future<Either<Failure, List<MediaEntity>>> getMediaForStory(String storyId);
  Future<Either<Failure, void>> deleteMedia(String mediaId);
}
