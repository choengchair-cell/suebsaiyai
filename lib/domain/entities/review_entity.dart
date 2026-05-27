import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  const ReviewEntity({
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

  @override
  List<Object?> get props => [id, storyId, reviewerId, decision, createdAt];
}

enum ReviewDecision {
  approved,
  rejected,
  needsRevision;

  String get displayName => switch (this) {
        ReviewDecision.approved => 'อนุมัติ',
        ReviewDecision.rejected => 'ปฏิเสธ',
        ReviewDecision.needsRevision => 'ต้องแก้ไข',
      };

  String get firestoreValue => name;

  static ReviewDecision fromFirestore(String value) =>
      ReviewDecision.values.firstWhere((e) => e.name == value, orElse: () => ReviewDecision.needsRevision);
}
