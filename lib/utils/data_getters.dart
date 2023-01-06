import 'dart:convert';

import 'package:flutter/services.dart';

Future<List<String>> loadAssetsList() async {
  // >> To get paths you need these 2 lines
  final manifestContent = await rootBundle.loadString('AssetManifest.json');

  final Map<String, dynamic> manifestMap = json.decode(manifestContent);
  // >> To get paths you need these 2 lines

  final imagePaths = manifestMap.keys
      .where((String key) => key.contains('transaction_images/'))
      .toList();

  return imagePaths;
}
