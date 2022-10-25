/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/anonymous.svg
  String get anonymous => 'assets/images/anonymous.svg';

  /// File path: assets/images/arrow_down.svg
  String get arrowDown => 'assets/images/arrow_down.svg';

  /// File path: assets/images/calendar.svg
  String get calendar => 'assets/images/calendar.svg';

  /// File path: assets/images/marker_add.svg
  String get markerAdd => 'assets/images/marker_add.svg';

  /// File path: assets/images/marker_base.svg
  String get markerBase => 'assets/images/marker_base.svg';

  /// File path: assets/images/marker_nonetap.png
  AssetGenImage get markerNonetap =>
      const AssetGenImage('assets/images/marker_nonetap.png');

  /// File path: assets/images/marker_ontap.png
  AssetGenImage get markerOntap =>
      const AssetGenImage('assets/images/marker_ontap.png');

  /// List of all assets
  List<dynamic> get values => [
        anonymous,
        arrowDown,
        calendar,
        markerAdd,
        markerBase,
        markerNonetap,
        markerOntap
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider() => AssetImage(_assetName);

  String get path => _assetName;

  String get keyName => _assetName;
}
