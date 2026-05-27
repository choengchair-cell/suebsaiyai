import 'package:flutter_test/flutter_test.dart';
import 'package:suebsaiyai/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('returns null for valid email', () {
      expect(Validators.email('user@example.com'), isNull);
    });

    test('returns error for empty', () {
      expect(Validators.email(''), isNotNull);
    });

    test('returns error for invalid format', () {
      expect(Validators.email('notanemail'), isNotNull);
    });
  });

  group('Validators.password', () {
    test('returns null for valid password', () {
      expect(Validators.password('password123'), isNull);
    });

    test('returns error for short password', () {
      expect(Validators.password('short'), isNotNull);
    });

    test('returns error for empty', () {
      expect(Validators.password(''), isNotNull);
    });
  });

  group('Validators.required', () {
    test('returns null for non-empty string', () {
      expect(Validators.required('hello'), isNull);
    });

    test('returns error for empty string', () {
      expect(Validators.required(''), isNotNull);
    });

    test('returns error for whitespace-only string', () {
      expect(Validators.required('   '), isNotNull);
    });
  });

  group('Validators.storyTitle', () {
    test('returns null for valid title', () {
      expect(Validators.storyTitle('ภูมิปัญญาชุมชน'), isNull);
    });

    test('returns error for empty title', () {
      expect(Validators.storyTitle(''), isNotNull);
    });

    test('returns error for title over 200 characters', () {
      expect(Validators.storyTitle('x' * 201), isNotNull);
    });
  });
}
