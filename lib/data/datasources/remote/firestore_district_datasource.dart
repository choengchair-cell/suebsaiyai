import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suebsaiyai/core/constants/firestore_constants.dart';
import 'package:suebsaiyai/data/models/district_model.dart';

class FirestoreDistrictDatasource {
  FirestoreDistrictDatasource(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestoreConstants.districts);

  Stream<List<DistrictModel>> watchAllDistricts() => _collection
      .orderBy('name')
      .snapshots()
      .map((s) => s.docs.map((d) => DistrictModel.fromFirestore(d)).toList());

  Future<List<DistrictModel>> getAllDistricts() async {
    final snap = await _collection.orderBy('name').get();
    return snap.docs.map((d) => DistrictModel.fromFirestore(d)).toList();
  }

  Future<DistrictModel?> getDistrict(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return DistrictModel.fromFirestore(doc);
  }
}
