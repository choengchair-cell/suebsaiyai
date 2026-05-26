import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suebsaiyai/application/providers/repository_providers.dart';
import 'package:suebsaiyai/application/story/story_list_state.dart';
import 'package:suebsaiyai/domain/repositories/story_repository.dart';

class PublishedStoriesNotifier extends StateNotifier<StoryListState> {
  PublishedStoriesNotifier(this._repo, {this.districtId}) : super(const StoryListInitial()) {
    _listen();
  }

  final StoryRepository _repo;
  final String? districtId;
  StreamSubscription? _sub;

  void _listen() {
    state = const StoryListLoading();
    _sub = _repo.watchPublishedStories(districtId: districtId).listen(
      (stories) => state = StoryListLoaded(stories),
      onError: (e) => state = StoryListError(e.toString()),
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final publishedStoriesProvider = StateNotifierProvider.autoDispose<PublishedStoriesNotifier, StoryListState>(
  (ref) => PublishedStoriesNotifier(ref.watch(storyRepositoryProvider)),
);

final myStoriesProvider = StateNotifierProvider.autoDispose<PublishedStoriesNotifier, StoryListState>((ref) {
  // Placeholder — in real use, inject current user's authorId
  return PublishedStoriesNotifier(ref.watch(storyRepositoryProvider));
});
