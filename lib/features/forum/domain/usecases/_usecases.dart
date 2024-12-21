import 'package:baket_mobile/core/bases/use_case/use_case.dart';
import 'package:baket_mobile/core/constants/_constants.dart';
import 'package:baket_mobile/core/errors/failure.dart';
import 'package:baket_mobile/core/parsed.dart';
import 'package:baket_mobile/features/forum/domain/models/post_model.dart';
import 'package:baket_mobile/features/forum/domain/params/add_post_params.dart';
import 'package:baket_mobile/features/forum/domain/params/like_params.dart';
import 'package:baket_mobile/features/forum/domain/params/post_params.dart';
import 'package:baket_mobile/features/forum/domain/repositories/_repositories.dart';
import 'package:either_dart/either.dart';

part 'post_use_case.dart';
part 'like_use_case.dart';
part 'add_post_use_case.dart';
