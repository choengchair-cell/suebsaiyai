import 'package:dartz/dartz.dart';
import 'package:suebsaiyai/core/errors/failure.dart';
import 'package:suebsaiyai/domain/entities/review_entity.dart';

abstract class ReviewRepository {
  Future<Either<Failure, ReviewEntity>> createReview(ReviewEntity review);
  Future<Either<Failure, List<ReviewEntity>>> getReviewsForStory(String storyId);
  Stream<List<ReviewEntity>> watchReviewsForStory(String storyId);
  Future<Either<Failure, ReviewEntity>> updateReview(ReviewEntity review);
}
