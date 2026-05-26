import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suebsaiyai/domain/entities/story_entity.dart';
import 'package:suebsaiyai/domain/enums/story_status.dart';

class StoryModel {
  const StoryModel({
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

  factory StoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StoryModel(
      id: doc.id,
      title: data['title'] as String,
      content: data['content'] as String,
      authorId: data['authorId'] as String,
      authorName: data['authorName'] as String?,
      districtId: data['districtId'] as String? ?? '',
      status: StoryStatus.fromFirestore(data['status'] as String? ?? 'draft'),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      coverImageUrl: data['coverImageUrl'] as String?,
      summary: data['summary'] as String?,
      tags: List<String>.from(data['tags'] as List? ?? []),
      culturalTermIds: List<String>.from(data['culturalTermIds'] as List? ?? []),
      taxonomyIds: List<String>.from(data['taxonomyIds'] as List? ?? []),
      mediaIds: List<String>.from(data['mediaIds'] as List? ?? []),
      currentVersionId: data['currentVersionId'] as String?,
      publishedAt: (data['publishedAt'] as Timestamp?)?.toDate(),
      viewCount: data['viewCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'content': content,
        'authorId': authorId,
        if (authorName != null) 'authorName': authorName,
        'districtId': districtId,
        'status': status.firestoreValue,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
        if (coverImageUrl != null) 'coverImageUrl': coverImageUrl,
        if (summary != null) 'summary': summary,
        'tags': tags,
        'culturalTermIds': culturalTermIds,
        'taxonomyIds': taxonomyIds,
        'mediaIds': mediaIds,
        if (currentVersionId != null) 'currentVersionId': currentVersionId,
        if (publishedAt != null) 'publishedAt': Timestamp.fromDate(publishedAt!),
        'viewCount': viewCount,
      };

  StoryEntity toEntity() => StoryEntity(
        id: id,
        title: title,
        content: content,
        authorId: authorId,
        authorName: authorName,
        districtId: districtId,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
        coverImageUrl: coverImageUrl,
        summary: summary,
        tags: tags,
        culturalTermIds: culturalTermIds,
        taxonomyIds: taxonomyIds,
        mediaIds: mediaIds,
        currentVersionId: currentVersionId,
        publishedAt: publishedAt,
        viewCount: viewCount,
      );

  factory StoryModel.fromEntity(StoryEntity entity) => StoryModel(
        id: entity.id,
        title: entity.title,
        content: entity.content,
        authorId: entity.authorId,
        authorName: entity.authorName,
        districtId: entity.districtId,
        status: entity.status,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        coverImageUrl: entity.coverImageUrl,
        summary: entity.summary,
        tags: entity.tags,
        culturalTermIds: entity.culturalTermIds,
        taxonomyIds: entity.taxonomyIds,
        mediaIds: entity.mediaIds,
        currentVersionId: entity.currentVersionId,
        publishedAt: entity.publishedAt,
        viewCount: entity.viewCount,
      );
}
