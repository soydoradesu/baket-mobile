part of '_constants.dart';

class Assets {
  static final svg = _SvgAssets();
  static final image = _ImageAssets();
}

class _SvgAssets {
  final String _basePath = 'assets/svgs';

  String get logoPanjang => '$_basePath/LogoPanjang.svg';
  String get noPost => '$_basePath/NoPost.svg';
  String get error => '$_basePath/Error.svg';
  String get reply => '$_basePath/Reply.svg';
}

class _ImageAssets {
  final String _basePath = 'assets/images';

  String get logoBG => '$_basePath/BaKet_Logo_BG.png';
  String get logoWhite => '$_basePath/BaKet_Logo_White.png';
  String get logoBlue => '$_basePath/BaKet_Logo.png';
  String get branding => '$_basePath/branding.png';
}
