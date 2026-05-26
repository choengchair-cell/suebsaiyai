import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:suebsaiyai/core/errors/failure.dart';
import 'package:suebsaiyai/data/datasources/remote/firebase_auth_datasource.dart';
import 'package:suebsaiyai/data/datasources/remote/firestore_user_datasource.dart';
import 'package:suebsaiyai/data/models/user_model.dart';
import 'package:suebsaiyai/domain/entities/user_entity.dart';
import 'package:suebsaiyai/domain/enums/user_role.dart';
import 'package:suebsaiyai/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authDs, this._userDs);
  final FirebaseAuthDatasource _authDs;
  final FirestoreUserDatasource _userDs;

  @override
  Stream<UserEntity?> get authStateChanges => _authDs.authStateChanges.asyncMap((user) async {
        if (user == null) return null;
        return (await _userDs.getUser(user.uid))?.toEntity();
      });

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _authDs.signInWithEmailAndPassword(email, password);
      final user = await _userDs.getUser(cred.user!.uid);
      if (user == null) return const Left(AuthFailure('ไม่พบข้อมูลผู้ใช้'));
      return Right(user.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseError(e.code)));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
    String email,
    String password,
    String displayName,
    String districtId,
  ) async {
    try {
      final cred = await _authDs.createUserWithEmailAndPassword(email, password);
      final model = UserModel(
        uid: cred.user!.uid,
        email: email,
        displayName: displayName,
        role: UserRole.field,
        districtId: districtId,
        createdAt: DateTime.now(),
      );
      await _userDs.createUser(model);
      return Right(model.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseError(e.code)));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _authDs.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await _authDs.sendPasswordResetEmail(email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseError(e.code)));
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _authDs.currentUser;
    if (user == null) return null;
    return (await _userDs.getUser(user.uid))?.toEntity();
  }

  String _mapFirebaseError(String code) => switch (code) {
        'user-not-found' => 'ไม่พบอีเมลนี้ในระบบ',
        'wrong-password' => 'รหัสผ่านไม่ถูกต้อง',
        'email-already-in-use' => 'อีเมลนี้ถูกใช้งานแล้ว',
        'weak-password' => 'รหัสผ่านไม่ปลอดภัยพอ',
        'invalid-email' => 'รูปแบบอีเมลไม่ถูกต้อง',
        'too-many-requests' => 'พยายามเข้าสู่ระบบหลายครั้งเกินไป กรุณารอสักครู่',
        _ => 'เกิดข้อผิดพลาด: $code',
      };
}
