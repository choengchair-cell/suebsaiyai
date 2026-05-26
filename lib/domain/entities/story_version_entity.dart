import 'package:equatable/equatable.dart';

class StoryVersionEntity extends Equatable {
  const StoryVersionEntity({
    required this.id,
    required this.storyId,
    required this.title,
    required this.content,
    required this.createdBy,
    required this.createdAt,
    required this.versionNumber,
    this.changeNote,
    this.snapshotStatus,
  });

  final String id;
  final String storyId;
  final String title;
  final String content;
  final String createdBy;
  final DateTime createdAt;
  final int versionNumber;
  final String? changeNote;
  final String? snapshotStatus;

  @override
  List<Object?> get props => [id, storyId, versionNumber, createdAt];
}
