import 'package:dartz/dartz.dart';
import 'package:suebsaiyai/core/errors/failure.dart';
import 'package:suebsaiyai/domain/entities/user_entity.dart';
import 'package:suebsaiyai/domain/enums/user_role.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUser(String uid);
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user);
  Future<Either<Failure, void>> updateUserRole(String uid, UserRole role);
  Future<Either<Failure, List<UserEntity>>> getUsersByDistrict(String districtId);
  Stream<UserEntity> watchUser(String uid);
}
