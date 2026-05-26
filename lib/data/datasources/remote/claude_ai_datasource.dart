import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:suebsaiyai/core/constants/app_constants.dart';
import 'package:suebsaiyai/core/errors/app_exception.dart';

class ClaudeAiDatasource {
  ClaudeAiDatasource(this._dio, this._apiKey);
  final Dio _dio;
  final String _apiKey;

  static const _maxRetries = 3;

  Future<String> generateSummary(String storyContent) async {
    final prompt = '''
คุณเป็นผู้ช่วยอนุรักษ์ภูมิปัญญาชุมชน
สรุปเนื้อหาต่อไปนี้เป็นภาษาไทย ความยาวไม่เกิน 3 ย่อหน้า
เน้นสาระสำคัญและคุณค่าทางวัฒนธรรม

เนื้อหา:
$storyContent

ตอบเฉพาะบทสรุปเท่านั้น ไม่ต้องมีคำนำหรือคำลงท้าย
''';

    return _sendRequest(prompt);
  }

  Future<List<String>> suggestTags(String storyContent) async {
    final prompt = '''
วิเคราะห์เนื้อหาต่อไปนี้และเสนอแท็กที่เหมาะสมสำหรับการจัดหมวดหมู่ภูมิปัญญาชุมชน
ตอบในรูปแบบ JSON array เท่านั้น เช่น ["แท็ก1","แท็ก2","แท็ก3"]
แท็กควรเป็นภาษาไทย ไม่เกิน 10 แท็ก

เนื้อหา:
$storyContent
''';

    final response = await _sendRequest(prompt);
    try {
      final cleaned = response.trim().replaceAll(RegExp(r'^```json\n?'), '').replaceAll(RegExp(r'\n?```$'), '');
      final decoded = jsonDecode(cleaned) as List;
      return decoded.cast<String>();
    } catch (_) {
      return [];
    }
  }

  Future<String> _sendRequest(String prompt, {int attempt = 0}) async {
    try {
      final response = await _dio.post(
        'https://api.anthropic.com/v1/messages',
        options: Options(
          headers: {
            'x-api-key': _apiKey,
            'anthropic-version': '2023-06-01',
            'content-type': 'application/json',
          },
          receiveTimeout: AppConstants.aiRequestTimeout,
        ),
        data: {
          'model': AppConstants.claudeModel,
          'max_tokens': 1024,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
        },
      );

      final content = response.data['content'] as List;
      if (content.isEmpty) throw const AppException('Empty AI response');
      return (content.first as Map<String, dynamic>)['text'] as String;
    } on DioException catch (e) {
      if (attempt < _maxRetries && (e.type == DioExceptionType.connectionTimeout || e.response?.statusCode == 529)) {
        await Future.delayed(Duration(seconds: (attempt + 1) * 2));
        return _sendRequest(prompt, attempt: attempt + 1);
      }
      throw AppException('AI request failed: ${e.message}', code: e.response?.statusCode?.toString());
    }
  }
}
