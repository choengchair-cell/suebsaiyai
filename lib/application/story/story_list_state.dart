import 'package:equatable/equatable.dart';
import 'package:suebsaiyai/domain/entities/story_entity.dart';

abstract class StoryListState extends Equatable {
  const StoryListState();
  @override
  List<Object?> get props => [];
}

class StoryListInitial extends StoryListState {
  const StoryListInitial();
}

class StoryListLoading extends StoryListState {
  const StoryListLoading();
}

class StoryListLoaded extends StoryListState {
  const StoryListLoaded(this.stories, {this.hasMore = false});
  final List<StoryEntity> stories;
  final bool hasMore;

  @override
  List<Object?> get props => [stories, hasMore];
}

class StoryListError extends StoryListState {
  const StoryListError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
