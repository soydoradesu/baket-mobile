// Parameter and queries for get post

import 'package:pbp_django_auth/pbp_django_auth.dart';

class ReplyParams {
  final CookieRequest request;
  final String postId;
  final String url;
  final int limit;
  final int page;

  ReplyParams({
    required this.request,
    required this.postId,
    required this.url,
    required this.limit,
    required this.page,
  });
}
