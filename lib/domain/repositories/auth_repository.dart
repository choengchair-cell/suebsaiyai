import 'package:dartz/dartz.dart';
import 'package:suebsaiyai/core/errors/failure.dart';
import 'package:suebsaiyai/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(String email, String password);
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(String email, String password, String displayName, String districtId);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
  Future<UserEntity?> getCurrentUser();
}
