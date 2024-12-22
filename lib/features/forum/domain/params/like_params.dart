// Parameter and queries for like/unlike post

import 'package:pbp_django_auth/pbp_django_auth.dart';

class LikeParams {
  final CookieRequest request;
  final String url;
  final String uuid;
  final bool isPost;

  LikeParams({
    required this.request,
    required this.url,
    required this.uuid,
    this.isPost = true,
  });
}
