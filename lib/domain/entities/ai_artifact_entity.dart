import 'package:equatable/equatable.dart';
import 'package:suebsaiyai/domain/enums/ai_artifact_type.dart';

class AiArtifactEntity extends Equatable {
  const AiArtifactEntity({
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

  @override
  List<Object?> get props => [id, storyId, type, createdAt];
}
