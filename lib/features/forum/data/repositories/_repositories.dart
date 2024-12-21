import 'package:baket_mobile/core/api_call.dart';
import 'package:baket_mobile/core/errors/failure.dart';
import 'package:baket_mobile/core/parsed.dart';
import 'package:baket_mobile/features/forum/data/datasources/_datasources.dart';
import 'package:baket_mobile/features/forum/domain/models/post_model.dart';
import 'package:baket_mobile/features/forum/domain/params/add_post_params.dart';
import 'package:baket_mobile/features/forum/domain/params/like_params.dart';
import 'package:baket_mobile/features/forum/domain/params/post_params.dart';
import 'package:baket_mobile/features/forum/domain/repositories/_repositories.dart';
import 'package:either_dart/either.dart';

part 'post_repository_impl.dart';