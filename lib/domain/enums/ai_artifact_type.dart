enum AiArtifactType {
  summary,
  tags,
  keywords,
  transliteration,
  searchIndex,
  recommendation;

  String get displayName => switch (this) {
        AiArtifactType.summary => 'บทสรุป',
        AiArtifactType.tags => 'แท็กอัตโนมัติ',
        AiArtifactType.keywords => 'คำสำคัญ',
        AiArtifactType.transliteration => 'อักษรโรมัน',
        AiArtifactType.searchIndex => 'ดัชนีค้นหา',
        AiArtifactType.recommendation => 'คำแนะนำ',
      };

  String get firestoreValue => name;

  static AiArtifactType fromFirestore(String value) =>
      AiArtifactType.values.firstWhere((e) => e.name == value, orElse: () => AiArtifactType.summary);
}
