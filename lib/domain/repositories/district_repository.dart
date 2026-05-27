import 'package:dartz/dartz.dart';
import 'package:suebsaiyai/core/errors/failure.dart';
import 'package:suebsaiyai/domain/entities/district_entity.dart';

abstract class DistrictRepository {
  Future<Either<Failure, List<DistrictEntity>>> getAllDistricts();
  Future<Either<Failure, DistrictEntity>> getDistrict(String id);
  Stream<List<DistrictEntity>> watchAllDistricts();
}
