import 'package:equatable/equatable.dart';

class CulturalTermEntity extends Equatable {
  const CulturalTermEntity({
    required this.id,
    required this.term,
    required this.definition,
    required this.districtId,
    required this.createdBy,
    required this.createdAt,
    this.pronunciation,
    this.alternateSpellings = const [],
    this.relatedTermIds = const [],
    this.examples = const [],
    this.mediaIds = const [],
    this.updatedAt,
  });

  final String id;
  final String term;
  final String definition;
  final String? pronunciation;
  final List<String> alternateSpellings;
  final List<String> relatedTermIds;
  final List<String> examples;
  final List<String> mediaIds;
  final String districtId;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [id, term, districtId, createdAt];
}
