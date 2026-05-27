import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suebsaiyai/core/constants/firestore_constants.dart';
import 'package:suebsaiyai/data/models/user_model.dart';

class FirestoreUserDatasource {
  FirestoreUserDatasource(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestoreConstants.users);

  Stream<UserModel?> watchUser(String uid) => _collection.doc(uid).snapshots().map(
        (doc) => doc.exists ? UserModel.fromFirestore(doc) : null,
      );

  Future<UserModel?> getUser(String uid) async {
    final doc = await _collection.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  Future<void> createUser(UserModel user) =>
      _collection.doc(user.uid).set(user.toFirestore());

  Future<void> updateUser(String uid, Map<String, dynamic> data) =>
      _collection.doc(uid).update(data);

  Future<List<UserModel>> getUsersByDistrict(String districtId) async {
    final snap = await _collection
        .where('districtId', isEqualTo: districtId)
        .get();
    return snap.docs.map((d) => UserModel.fromFirestore(d)).toList();
  }
}
