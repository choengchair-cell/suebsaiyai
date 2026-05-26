import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suebsaiyai/domain/entities/ai_artifact_entity.dart';
import 'package:suebsaiyai/domain/enums/ai_artifact_type.dart';

class AiArtifactModel {
  const AiArtifactModel({
    required this.id,
    required this.storyId,
    required this.type,
    required this.content,
    required this.createdAt,
    required this.modelVersion,
    this.isHumanValidated = false,
    this.validatedBy,
    this.validatedAt,
    this.confidence,
    this.metadata = const {},
  });

  final String id;
  final String storyId;
  final AiArtifactType type;
  final dynamic content;
  final DateTime createdAt;
  final String modelVersion;
  final bool isHumanValidated;
  final String? validatedBy;
  final DateTime? validatedAt;
  final double? confidence;
  final Map<String, dynamic> metadata;

  factory AiArtifactModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AiArtifactModel(
      id: doc.id,
      storyId: data['storyId'] as String,
      type: AiArtifactType.fromFirestore(data['type'] as String? ?? 'summary'),
      content: data['content'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      modelVersion: data['modelVersion'] as String? ?? '',
      isHumanValidated: data['isHumanValidated'] as bool? ?? false,
      validatedBy: data['validatedBy'] as String?,
      validatedAt: (data['validatedAt'] as Timestamp?)?.toDate(),
      confidence: (data['confidence'] as num?)?.toDouble(),
      metadata: Map<String, dynamic>.from(data['metadata'] as Map? ?? {}),
    );
  }

  AiArtifactEntity toEntity() => AiArtifactEntity(
        id: id,
        storyId: storyId,
        type: type,
        content: content,
        createdAt: createdAt,
        modelVersion: modelVersion,
        isHumanValidated: isHumanValidated,
        validatedBy: validatedBy,
        validatedAt: validatedAt,
        confidence: confidence,
        metadata: metadata,
      );
}
