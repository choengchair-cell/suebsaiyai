class AppConstants {
  AppConstants._();

  static const String appName = 'สืบสายใย';
  static const String appNameEn = 'Suebsaiyai';
  static const String appTagline = 'อนุรักษ์ภูมิปัญญาชุมชน';

  static const int paginationLimit = 20;
  static const int maxImageSizeMb = 10;
  static const int maxAudioSizeMb = 100;
  static const int maxVideoSizeMb = 500;
  static const int maxTitleLength = 200;
  static const int maxContentLength = 50000;
  static const int minContentLength = 50;

  static const Duration cacheTimeout = Duration(minutes: 15);
  static const Duration aiRequestTimeout = Duration(seconds: 60);
  static const Duration networkTimeout = Duration(seconds: 30);

  static const String claudeModel = 'claude-opus-4-7';

  static const List<String> supportedImageTypes = ['image/jpeg', 'image/png', 'image/webp'];
  static const List<String> supportedAudioTypes = ['audio/mpeg', 'audio/wav', 'audio/ogg', 'audio/mp4'];
  static const List<String> supportedVideoTypes = ['video/mp4', 'video/webm'];
}
