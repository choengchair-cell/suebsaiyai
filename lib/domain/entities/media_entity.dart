import 'package:equatable/equatable.dart';
import 'package:suebsaiyai/domain/enums/media_type.dart';

class MediaEntity extends Equatable {
  const MediaEntity({
    required this.id,
    required this.storyId,
    required this.type,
    required this.url,
    required this.uploadedBy,
    required this.uploadedAt,
    required this.fileName,
    this.thumbnailUrl,
    this.caption,
    this.mimeType,
    this.sizeBytes,
    this.durationSeconds,
    this.width,
    this.height,
    this.isApproved = false,
    this.metadata = const {},
  });

  final String id;
  final String storyId;
  final MediaType type;
  final String url;
  final String? thumbnailUrl;
  final String uploadedBy;
  final DateTime uploadedAt;
  final String fileName;
  final String? caption;
  final String? mimeType;
  final int? sizeBytes;
  final int? durationSeconds;
  final int? width;
  final int? height;
  final bool isApproved;
  final Map<String, dynamic> metadata;

  @override
  List<Object?> get props => [id, storyId, type, url, uploadedBy];
}
