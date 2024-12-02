part of '_constants.dart';

class Assets {
  static final svg = _SvgAssets();
  static final image = _ImageAssets();
}

class _SvgAssets {
  final String _basePath = 'assets/svgs';

  String get logo => '$_basePath/logo.svg';
  String get textResize => '$_basePath/text_resize.svg';
  String get caretDownFill => '$_basePath/caret_down_fill.svg';
  String get caretUpFill => '$_basePath/caret_up_fill.svg';
  String get chevronCompactDown => '$_basePath/chevron_compact_down.svg';
  String get chevronCompactUp => '$_basePath/chevron_compact_up.svg';
}

class _ImageAssets {
  final String _basePath = 'assets/images';

  String get logoHorizontal => '$_basePath/logo_horizontal.png';
  String get furinaSad => '$_basePath/furina_sad.png';
}
