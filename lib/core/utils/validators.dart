class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'กรุณากรอกอีเมล';
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value)) return 'รูปแบบอีเมลไม่ถูกต้อง';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'กรุณากรอกรหัสผ่าน';
    if (value.length < 8) return 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร';
    return null;
  }

  static String? required(String? value, {String fieldName = 'ข้อมูล'}) {
    if (value == null || value.trim().isEmpty) return 'กรุณากรอก$fieldName';
    return null;
  }

  static String? storyTitle(String? value) {
    if (value == null || value.trim().isEmpty) return 'กรุณากรอกชื่อเรื่อง';
    if (value.length > 200) return 'ชื่อเรื่องยาวเกินไป (สูงสุด 200 ตัวอักษร)';
    return null;
  }

  static String? storyContent(String? value) {
    if (value == null || value.trim().isEmpty) return 'กรุณากรอกเนื้อหา';
    if (value.length < 50) return 'เนื้อหาสั้นเกินไป (ต้องมีอย่างน้อย 50 ตัวอักษร)';
    return null;
  }
}
