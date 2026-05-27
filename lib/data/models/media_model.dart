import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suebsaiyai/domain/entities/media_entity.dart';
import 'package:suebsaiyai/domain/enums/media_type.dart';

class MediaModel {
  const MediaModel({
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

  factory MediaModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MediaModel(
      id: doc.id,
      storyId: data['storyId'] as String,
      type: MediaType.fromFirestore(data['type'] as String? ?? 'document'),
      url: data['url'] as String,
      thumbnailUrl: data['thumbnailUrl'] as String?,
      uploadedBy: data['uploadedBy'] as String,
      uploadedAt: (data['uploadedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      fileName: data['fileName'] as String? ?? '',
      caption: data['caption'] as String?,
      mimeType: data['mimeType'] as String?,
      sizeBytes: data['sizeBytes'] as int?,
      durationSeconds: data['durationSeconds'] as int?,
      width: data['width'] as int?,
      height: data['height'] as int?,
      isApproved: data['isApproved'] as bool? ?? false,
      metadata: Map<String, dynamic>.from(data['metadata'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'storyId': storyId,
        'type': type.firestoreValue,
        'url': url,
        if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
        'uploadedBy': uploadedBy,
        'uploadedAt': Timestamp.fromDate(uploadedAt),
        'fileName': fileName,
        if (caption != null) 'caption': caption,
        if (mimeType != null) 'mimeType': mimeType,
        if (sizeBytes != null) 'sizeBytes': sizeBytes,
        if (durationSeconds != null) 'durationSeconds': durationSeconds,
        if (width != null) 'width': width,
        if (height != null) 'height': height,
        'isApproved': isApproved,
        'metadata': metadata,
      };

  MediaEntity toEntity() => MediaEntity(
        id: id,
        storyId: storyId,
        type: type,
        url: url,
        thumbnailUrl: thumbnailUrl,
        uploadedBy: uploadedBy,
        uploadedAt: uploadedAt,
        fileName: fileName,
        caption: caption,
        mimeType: mimeType,
        sizeBytes: sizeBytes,
        durationSeconds: durationSeconds,
        width: width,
        height: height,
        isApproved: isApproved,
        metadata: metadata,
      );
}
