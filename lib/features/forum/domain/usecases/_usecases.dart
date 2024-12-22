import 'package:baket_mobile/core/bases/use_case/use_case.dart';
import 'package:baket_mobile/core/errors/failure.dart';
import 'package:baket_mobile/core/parsed.dart';
import 'package:baket_mobile/features/forum/domain/params/manage_post_params.dart';
import 'package:baket_mobile/features/forum/domain/params/like_params.dart';
import 'package:baket_mobile/features/forum/domain/params/manage_reply_params.dart';
import 'package:baket_mobile/features/forum/domain/params/post_params.dart';
import 'package:baket_mobile/features/forum/domain/params/reply_params.dart';
import 'package:baket_mobile/features/forum/domain/repositories/_repositories.dart';
import 'package:either_dart/either.dart';

part 'like_use_case.dart';

part 'post_use_case.dart';
part 'add_post_use_case.dart';
part 'edit_post_use_case.dart';
part 'delete_post_use_case.dart';

part 'reply_use_case.dart';
part 'add_reply_use_case.dart';
part 'delete_reply_use_case.dart';
