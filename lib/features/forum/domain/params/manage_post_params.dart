// Parameter and queries for add and edit post

import 'dart:io';

import 'package:pbp_django_auth/pbp_django_auth.dart';

class ManagePostParams {
  final CookieRequest request;
  final String url;
  final String content;
  final File? image;

  ManagePostParams({
    required this.request,
    required this.url,
    required this.content,
    this.image,
  });
}
