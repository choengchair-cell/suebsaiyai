import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suebsaiyai/domain/entities/user_entity.dart';
import 'package:suebsaiyai/domain/enums/user_role.dart';

class UserModel {
  const UserModel({
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

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] as String,
      displayName: data['displayName'] as String,
      role: UserRole.values.firstWhere(
        (r) => r.name == (data['role'] as String? ?? 'field'),
        orElse: () => UserRole.field,
      ),
      districtId: data['districtId'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      avatarUrl: data['avatarUrl'] as String?,
      bio: data['bio'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'role': role.name,
        'districtId': districtId,
        'createdAt': Timestamp.fromDate(createdAt),
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
        if (bio != null) 'bio': bio,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
        'isActive': isActive,
      };

  UserEntity toEntity() => UserEntity(
        uid: uid,
        email: email,
        displayName: displayName,
        role: role,
        districtId: districtId,
        createdAt: createdAt,
        avatarUrl: avatarUrl,
        bio: bio,
        phoneNumber: phoneNumber,
        isActive: isActive,
      );

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        uid: entity.uid,
        email: entity.email,
        displayName: entity.displayName,
        role: entity.role,
        districtId: entity.districtId,
        createdAt: entity.createdAt,
        avatarUrl: entity.avatarUrl,
        bio: entity.bio,
        phoneNumber: entity.phoneNumber,
        isActive: entity.isActive,
      );
}
