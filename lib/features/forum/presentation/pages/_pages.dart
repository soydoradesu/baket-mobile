import 'dart:io';

import 'package:baket_mobile/core/bases/decorators/input_decorator.dart';
import 'package:baket_mobile/core/bases/widgets/_widgets.dart';
import 'package:baket_mobile/core/constants/_constants.dart';
import 'package:baket_mobile/core/errors/failure.dart';
import 'package:baket_mobile/core/themes/_themes.dart';
import 'package:baket_mobile/features/forum/data/datasources/_datasources.dart';
import 'package:baket_mobile/features/forum/data/repositories/_repositories.dart';
import 'package:baket_mobile/features/forum/domain/models/post_model.dart';
import 'package:baket_mobile/features/forum/domain/params/add_post_params.dart';
import 'package:baket_mobile/features/forum/domain/usecases/_usecases.dart';
import 'package:baket_mobile/features/forum/presentation/widgets/_widgets.dart';
import 'package:baket_mobile/services/pref_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

part 'forum_page.dart';
part 'add_post_page.dart';
part 'image_preview_page.dart';
