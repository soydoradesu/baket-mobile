// Parameter and queries for add and edit post

import 'package:pbp_django_auth/pbp_django_auth.dart';

class ManageReplyParams {
  final CookieRequest request;
  final String postId;
  final String url;
  final String content;

  ManageReplyParams({
    required this.request,
    required this.postId,
    required this.url,
    required this.content,
  });
}
