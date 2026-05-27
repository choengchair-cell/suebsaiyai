enum UserRole {
  field,
  teacher,
  committee,
  admin;

  String get displayName => switch (this) {
        UserRole.field => 'นักสืบค้น',
        UserRole.teacher => 'ครู/ที่ปรึกษา',
        UserRole.committee => 'คณะกรรมการ',
        UserRole.admin => 'ผู้ดูแลระบบ',
      };

  bool get canReview => this == UserRole.teacher || this == UserRole.committee || this == UserRole.admin;
  bool get canPublish => this == UserRole.committee || this == UserRole.admin;
  bool get canManageUsers => this == UserRole.admin;
}
