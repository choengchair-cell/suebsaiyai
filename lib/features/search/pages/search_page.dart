import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suebsaiyai/application/providers/repository_providers.dart';
import 'package:suebsaiyai/domain/entities/story_entity.dart';
import 'package:suebsaiyai/features/story/widgets/story_card.dart';

final _searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');
final _searchResultsProvider = FutureProvider.autoDispose<List<StoryEntity>>((ref) async {
  final query = ref.watch(_searchQueryProvider);
  if (query.length < 2) return [];
  final result = await ref.watch(storyRepositoryProvider).searchStories(query);
  return result.fold((f) => [], (stories) => stories);
});

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(_searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _ctrl,
          decoration: const InputDecoration(hintText: 'ค้นหาเรื่องราว...', border: InputBorder.none),
          autofocus: true,
          onChanged: (v) => ref.read(_searchQueryProvider.notifier).state = v,
        ),
      ),
      body: results.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (stories) => stories.isEmpty
            ? const Center(child: Text('ไม่พบผลลัพธ์'))
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 360, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.1),
                itemCount: stories.length,
                itemBuilder: (context, i) => StoryCard(story: stories[i]),
              ),
      ),
    );
  }
}
