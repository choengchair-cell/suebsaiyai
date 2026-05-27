import 'package:equatable/equatable.dart';

class TaxonomyEntity extends Equatable {
  const TaxonomyEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.createdBy,
    required this.createdAt,
    this.description,
    this.parentId,
    this.storyCount = 0,
  });

  final String id;
  final String name;
  final String category;
  final String? description;
  final String? parentId;
  final String createdBy;
  final DateTime createdAt;
  final int storyCount;

  @override
  List<Object?> get props => [id, name, category];
}
