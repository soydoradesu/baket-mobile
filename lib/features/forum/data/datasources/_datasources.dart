import 'dart:convert';

import 'package:baket_mobile/services/pref_service.dart';
import 'package:http/http.dart';
import 'package:baket_mobile/core/parsed.dart';
import 'package:baket_mobile/features/forum/domain/models/post_model.dart';
import 'package:baket_mobile/features/forum/domain/params/add_post_params.dart';
import 'package:baket_mobile/features/forum/domain/params/like_params.dart';
import 'package:baket_mobile/features/forum/domain/params/post_params.dart';
import 'package:baket_mobile/services/logger_service.dart';

part 'post_remote_data_source.dart';
