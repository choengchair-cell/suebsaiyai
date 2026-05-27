import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suebsaiyai/core/constants/firestore_constants.dart';
import 'package:suebsaiyai/data/models/story_model.dart';

class FirestoreStoryDatasource {
  FirestoreStoryDatasource(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestoreConstants.stories);

  Stream<List<StoryModel>> watchPublishedStories({String? districtId, int limit = 20}) {
    Query<Map<String, dynamic>> query = _collection
        .where(FirestoreConstants.fieldStatus, isEqualTo: 'published')
        .orderBy(FirestoreConstants.fieldCreatedAt, descending: true)
        .limit(limit);
    if (districtId != null) {
      query = query.where(FirestoreConstants.fieldDistrictId, isEqualTo: districtId);
    }
    return query.snapshots().map((s) => s.docs.map((d) => StoryModel.fromFirestore(d)).toList());
  }

  Stream<List<StoryModel>> watchStoriesByAuthor(String authorId) =>
      _collection
          .where(FirestoreConstants.fieldAuthorId, isEqualTo: authorId)
          .orderBy(FirestoreConstants.fieldCreatedAt, descending: true)
          .snapshots()
          .map((s) => s.docs.map((d) => StoryModel.fromFirestore(d)).toList());

  Stream<List<StoryModel>> watchStoriesByStatus(String status) =>
      _collection
          .where(FirestoreConstants.fieldStatus, isEqualTo: status)
          .orderBy(FirestoreConstants.fieldCreatedAt, descending: true)
          .snapshots()
          .map((s) => s.docs.map((d) => StoryModel.fromFirestore(d)).toList());

  Future<StoryModel?> getStory(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return StoryModel.fromFirestore(doc);
  }

  Future<StoryModel> createStory(StoryModel story) async {
    final ref = _collection.doc();
    await ref.set(story.toFirestore());
    final created = await ref.get();
    return StoryModel.fromFirestore(created);
  }

  Future<void> updateStory(String id, Map<String, dynamic> data) async {
    await _collection.doc(id).update({
      ...data,
      FirestoreConstants.fieldUpdatedAt: FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteStory(String id) => _collection.doc(id).delete();

  Future<void> incrementViewCount(String id) =>
      _collection.doc(id).update({'viewCount': FieldValue.increment(1)});
}
