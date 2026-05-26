enum MediaType {
  image,
  audio,
  video,
  document;

  String get displayName => switch (this) {
        MediaType.image => 'รูปภาพ',
        MediaType.audio => 'เสียง',
        MediaType.video => 'วิดีโอ',
        MediaType.document => 'เอกสาร',
      };

  String get firestoreValue => name;

  static MediaType fromFirestore(String value) =>
      MediaType.values.firstWhere((e) => e.name == value, orElse: () => MediaType.document);
}
