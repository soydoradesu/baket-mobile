import 'dart:convert';

import 'package:baket_mobile/core/constants/_constants.dart';
import 'package:baket_mobile/core/parsed.dart';
import 'package:baket_mobile/features/forum/domain/models/post_model.dart';
import 'package:baket_mobile/features/forum/domain/models/reply_model.dart';
import 'package:baket_mobile/features/forum/domain/params/manage_post_params.dart';
import 'package:baket_mobile/features/forum/domain/params/like_params.dart';
import 'package:baket_mobile/features/forum/domain/params/manage_reply_params.dart';
import 'package:baket_mobile/features/forum/domain/params/post_params.dart';
import 'package:baket_mobile/features/forum/domain/params/reply_params.dart';
import 'package:baket_mobile/services/logger_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

part 'post_remote_data_source.dart';
part 'reply_remote_data_source.dart';
