import 'dart:convert';

import 'package:flutter/services.dart';

class PosesLoader {
  static final PosesLoader _singleton = PosesLoader._internal();

  factory PosesLoader() {
    return _singleton;
  }

  PosesLoader._internal();

  late Map<String, dynamic> _assets;

  Future<Map<String, dynamic>> _loadAssets() async {
    var myAssets = await rootBundle.loadString('AssetManifest.json');
    Map<String, dynamic> map = json.decode(myAssets);
    return map;
  }

  Future<List<String>> loadPreviewImages() async {
    _assets = await _loadAssets();
    var previewImages = _assets.keys
        .where((element) =>
            element.startsWith('assets/poses/previews') &&
            element.contains('.png'))
        .toList();

    previewImages.sort((a, b) => a.compareTo(b));

    return previewImages;
  }

  Future<List<String>> loadZoomedImages() async {
    _assets = await _loadAssets();
    var zoomedImages = _assets.keys
        .where((element) =>
            element.startsWith('assets/poses/zoomed') &&
            element.contains('~ipad'))
        .toList();

    zoomedImages.sort((a, b) => a.compareTo(b));

    return zoomedImages;
  }
}
