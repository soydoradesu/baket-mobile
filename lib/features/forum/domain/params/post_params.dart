// Parameter and queries for get post

import 'package:pbp_django_auth/pbp_django_auth.dart';

class PostParams {
  final CookieRequest request;
  final String url;
  final String query;
  final int limit;
  final int page;

  PostParams({
    required this.request,
    required this.url,
    required this.query,
    required this.limit,
    required this.page,
  });
}
