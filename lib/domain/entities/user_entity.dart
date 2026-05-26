import 'package:equatable/equatable.dart';
import 'package:suebsaiyai/domain/enums/user_role.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    required this.districtId,
    required this.createdAt,
    this.avatarUrl,
    this.bio,
    this.phoneNumber,
    this.isActive = true,
  });

  final String uid;
  final String email;
  final String displayName;
  final UserRole role;
  final String districtId;
  final DateTime createdAt;
  final String? avatarUrl;
  final String? bio;
  final String? phoneNumber;
  final bool isActive;

  UserEntity copyWith({
    String? displayName,
    String? avatarUrl,
    String? bio,
    String? phoneNumber,
    UserRole? role,
    bool? isActive,
  }) =>
      UserEntity(
        uid: uid,
        email: email,
        displayName: displayName ?? this.displayName,
        role: role ?? this.role,
        districtId: districtId,
        createdAt: createdAt,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        bio: bio ?? this.bio,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        isActive: isActive ?? this.isActive,
      );

  @override
  List<Object?> get props => [uid, email, displayName, role, districtId, createdAt, avatarUrl, bio, phoneNumber, isActive];
}
