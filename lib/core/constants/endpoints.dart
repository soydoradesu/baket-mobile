part of '_constants.dart';

class Endpoints {
  // Production
  static const String baseUrlProd = Config.baseUrlProd;

  // Local
  static const String baseUrlHp = Config.baseUrlHp;
  static const String baseUrlWeb = Config.baseUrlWeb;

  // Change this to switch between local and production
  static const String baseUrl = baseUrlWeb;

  static const String login = '$baseUrl/auth/login/';
  static const String register = '$baseUrl/auth/register/';
  static const String logout = '$baseUrl/auth/logout/';

  // Forum
  static const String feeds = '$baseUrl/feeds';
  static const String allPosts = '$feeds/api/json/post';
  static const String myPosts = '$feeds/api/json/post/user';
  static const String replies = '$feeds/api/json/reply';
}
