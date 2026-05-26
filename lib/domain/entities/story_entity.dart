import 'package:equatable/equatable.dart';
import 'package:suebsaiyai/domain/enums/story_status.dart';

class StoryEntity extends Equatable {
  const StoryEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.districtId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.authorName,
    this.coverImageUrl,
    this.summary,
    this.tags = const [],
    this.culturalTermIds = const [],
    this.taxonomyIds = const [],
    this.mediaIds = const [],
    this.currentVersionId,
    this.publishedAt,
    this.viewCount = 0,
  });

  final String id;
  final String title;
  final String content;
  final String authorId;
  final String? authorName;
  final String districtId;
  final StoryStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? coverImageUrl;
  final String? summary;
  final List<String> tags;
  final List<String> culturalTermIds;
  final List<String> taxonomyIds;
  final List<String> mediaIds;
  final String? currentVersionId;
  final DateTime? publishedAt;
  final int viewCount;

  bool get isPublic => status.isPubliclyVisible;
  bool get canEdit => status.isEditable;

  StoryEntity copyWith({
    String? title,
    String? content,
    String? coverImageUrl,
    String? summary,
    List<String>? tags,
    List<String>? culturalTermIds,
    List<String>? taxonomyIds,
    List<String>? mediaIds,
    StoryStatus? status,
    String? currentVersionId,
    DateTime? publishedAt,
    DateTime? updatedAt,
    int? viewCount,
  }) =>
      StoryEntity(
        id: id,
        title: title ?? this.title,
        content: content ?? this.content,
        authorId: authorId,
        authorName: authorName,
        districtId: districtId,
        status: status ?? this.status,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        coverImageUrl: coverImageUrl ?? this.coverImageUrl,
        summary: summary ?? this.summary,
        tags: tags ?? this.tags,
        culturalTermIds: culturalTermIds ?? this.culturalTermIds,
        taxonomyIds: taxonomyIds ?? this.taxonomyIds,
        mediaIds: mediaIds ?? this.mediaIds,
        currentVersionId: currentVersionId ?? this.currentVersionId,
        publishedAt: publishedAt ?? this.publishedAt,
        viewCount: viewCount ?? this.viewCount,
      );

  @override
  List<Object?> get props => [id, title, authorId, districtId, status, createdAt, updatedAt];
}
