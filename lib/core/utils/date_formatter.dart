import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final _thaiDate = DateFormat('d MMMM yyyy', 'th_TH');
  static final _thaiDateTime = DateFormat('d MMMM yyyy HH:mm', 'th_TH');
  static final _shortDate = DateFormat('dd/MM/yyyy');
  static final _iso = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

  static String toThaiDate(DateTime date) => _thaiDate.format(date);
  static String toThaiDateTime(DateTime date) => _thaiDateTime.format(date);
  static String toShortDate(DateTime date) => _shortDate.format(date);
  static String toIso(DateTime date) => _iso.format(date);

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 365) return '${(diff.inDays / 365).floor()} ปีที่แล้ว';
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} เดือนที่แล้ว';
    if (diff.inDays > 0) return '${diff.inDays} วันที่แล้ว';
    if (diff.inHours > 0) return '${diff.inHours} ชั่วโมงที่แล้ว';
    if (diff.inMinutes > 0) return '${diff.inMinutes} นาทีที่แล้ว';
    return 'เมื่อกี้';
  }
}
