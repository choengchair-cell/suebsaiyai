import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suebsaiyai/domain/entities/review_entity.dart';

class ReviewModel {
  const ReviewModel({
    required this.id,
    required this.storyId,
    required this.reviewerId,
    required this.reviewerName,
    required this.reviewerRole,
    required this.decision,
    required this.createdAt,
    this.comment,
    this.isFinal = false,
    this.updatedAt,
  });

  final String id;
  final String storyId;
  final String reviewerId;
  final String reviewerName;
  final String reviewerRole;
  final ReviewDecision decision;
  final String? comment;
  final bool isFinal;
  final DateTime createdAt;
  final DateTime? updatedAt;

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      storyId: data['storyId'] as String,
      reviewerId: data['reviewerId'] as String,
      reviewerName: data['reviewerName'] as String? ?? '',
      reviewerRole: data['reviewerRole'] as String? ?? '',
      decision: ReviewDecision.fromFirestore(data['decision'] as String? ?? 'needsRevision'),
      comment: data['comment'] as String?,
      isFinal: data['isFinal'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'storyId': storyId,
        'reviewerId': reviewerId,
        'reviewerName': reviewerName,
        'reviewerRole': reviewerRole,
        'decision': decision.firestoreValue,
        if (comment != null) 'comment': comment,
        'isFinal': isFinal,
        'createdAt': Timestamp.fromDate(createdAt),
        if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
      };

  ReviewEntity toEntity() => ReviewEntity(
        id: id,
        storyId: storyId,
        reviewerId: reviewerId,
        reviewerName: reviewerName,
        reviewerRole: reviewerRole,
        decision: decision,
        comment: comment,
        isFinal: isFinal,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
