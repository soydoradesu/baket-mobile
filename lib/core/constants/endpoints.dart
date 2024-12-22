part of '_constants.dart';

class Endpoints {
  // Production
  static const String baseUrlProd = Config.baseUrlProd;

  // Local
  static const String baseUrlHp = Config.baseUrlHp;
  static const String baseUrlWeb = Config.baseUrlWeb;

  // Change this to switch between local and production
  static const String baseUrl = baseUrlProd;

  // Auth
  static const String login = '$baseUrl/auth/login/';
  static const String register = '$baseUrl/auth/register/';
  static const String logout = '$baseUrl/auth/logout/';

  // Catalogue
  static const String catalogue = '$baseUrl/catalogue';
  static String reviews(String productId) =>
      '$catalogue/review-json/$productId';

  // Forum
  static const String feeds = '$baseUrl/feeds';
  static const String allPosts = '$feeds/api/json/post';
  static const String myPosts = '$feeds/api/json/post/user';
  static const String replies = '$feeds/api/json/reply';

  static const String addPost = '$feeds/api/create/post';
  static const String editPost = '$feeds/api/post-edit';
  static const String deletePost = '$feeds/api/post-delete';
  static const String likePost = '$feeds/api/post-like';
  static const String unlikePost = '$feeds/api/post-unlike';

  static const String addReply = '$feeds/api/create/reply';
  static const String deleteReply = '$feeds/api/reply-delete';
  static const String likeReply = '$feeds/api/reply-like';
  static const String unlikeReply = '$feeds/api/reply-unlike';

  static const String report = '$feeds/api/report';
}
