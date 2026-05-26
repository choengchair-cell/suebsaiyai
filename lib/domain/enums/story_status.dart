enum StoryStatus {
  draft,
  submitted,
  teacherReview,
  committeeReview,
  approved,
  published,
  archived;

  String get displayName => switch (this) {
        StoryStatus.draft => 'ร่าง',
        StoryStatus.submitted => 'ส่งแล้ว',
        StoryStatus.teacherReview => 'รอครูตรวจ',
        StoryStatus.committeeReview => 'รอคณะกรรมการ',
        StoryStatus.approved => 'อนุมัติแล้ว',
        StoryStatus.published => 'เผยแพร่แล้ว',
        StoryStatus.archived => 'เก็บถาวร',
      };

  String get firestoreValue => switch (this) {
        StoryStatus.draft => 'draft',
        StoryStatus.submitted => 'submitted',
        StoryStatus.teacherReview => 'teacher_review',
        StoryStatus.committeeReview => 'committee_review',
        StoryStatus.approved => 'approved',
        StoryStatus.published => 'published',
        StoryStatus.archived => 'archived',
      };

  static StoryStatus fromFirestore(String value) => switch (value) {
        'draft' => StoryStatus.draft,
        'submitted' => StoryStatus.submitted,
        'teacher_review' => StoryStatus.teacherReview,
        'committee_review' => StoryStatus.committeeReview,
        'approved' => StoryStatus.approved,
        'published' => StoryStatus.published,
        'archived' => StoryStatus.archived,
        _ => StoryStatus.draft,
      };

  bool get isPubliclyVisible => this == StoryStatus.published;
  bool get isEditable => this == StoryStatus.draft;
  bool get isUnderReview => this == StoryStatus.teacherReview || this == StoryStatus.committeeReview;
}
