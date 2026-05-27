class RouteConstants {
  RouteConstants._();

  // Public
  static const String home = '/';
  static const String explore = '/explore';
  static const String storyDetail = '/stories/:id';
  static const String districtDetail = '/districts/:id';
  static const String search = '/search';
  static const String glossary = '/glossary';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';

  // Protected (field user)
  static const String dashboard = '/dashboard';
  static const String myStories = '/my-stories';
  static const String storyCreate = '/stories/create';
  static const String storyEdit = '/stories/:id/edit';
  static const String profile = '/profile';

  // Review (teacher+)
  static const String reviewQueue = '/review';
  static const String reviewStory = '/review/:id';

  // Committee+
  static const String committeeQueue = '/committee';

  // Admin
  static const String adminPanel = '/admin';
  static const String adminUsers = '/admin/users';
  static const String adminDistricts = '/admin/districts';
  static const String adminTaxonomies = '/admin/taxonomies';
  static const String adminSystem = '/admin/system';
}
