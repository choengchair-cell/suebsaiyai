import 'package:dartz/dartz.dart';
import 'package:suebsaiyai/core/errors/failure.dart';
import 'package:suebsaiyai/data/datasources/remote/firestore_district_datasource.dart';
import 'package:suebsaiyai/domain/entities/district_entity.dart';
import 'package:suebsaiyai/domain/repositories/district_repository.dart';

class DistrictRepositoryImpl implements DistrictRepository {
  DistrictRepositoryImpl(this._ds);
  final FirestoreDistrictDatasource _ds;

  @override
  Future<Either<Failure, List<DistrictEntity>>> getAllDistricts() async {
    try {
      final models = await _ds.getAllDistricts();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DistrictEntity>> getDistrict(String id) async {
    try {
      final model = await _ds.getDistrict(id);
      if (model == null) return const Left(NotFoundFailure('ไม่พบอำเภอนี้'));
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<DistrictEntity>> watchAllDistricts() =>
      _ds.watchAllDistricts().map((list) => list.map((m) => m.toEntity()).toList());
}
