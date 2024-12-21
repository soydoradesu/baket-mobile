// Parameter and queries for add post

import 'dart:io';

import 'package:pbp_django_auth/pbp_django_auth.dart';

class AddPostParams {
  final CookieRequest request;
  final String url;
  final String content;
  final File? image;

  AddPostParams({
    required this.request,
    required this.url,
    required this.content,
    this.image,
  });
}
