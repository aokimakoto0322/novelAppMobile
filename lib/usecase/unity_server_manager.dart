// Live2DのWebGLをFlutterで表示するためのローカルサーバーを起動するユースケース

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

class UnityServerManager {
  HttpServer? _server;
  final int port = 8080;

  // 1. アセットをローカルストレージに展開する関数
  Future<String> prepareUnityFiles() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final unityDir = Directory('${appDocDir.path}/unity_webgl');

    // まだコピーされていなければ、assetsからファイルを展開する
    if (!await unityDir.exists()) {
      await unityDir.create(recursive: true);

      // コピーすべきUnityのファイル名リスト
      const filesToCopy = [
        'index.html',
        'TemplateData/style.css',
        'TemplateData/favicon.ico',
        'TemplateData/fullscreen-button.png',
        'TemplateData/webgl-logo.png',
        'TemplateData/unity-logo-dark.png',
        'TemplateData/progress-bar-empty-dark.png',
        'TemplateData/progress-bar-full-dark.png',
        'Build/unity_webgl.loader.js',
        'Build/unity_webgl.framework.js',
        'Build/unity_webgl.data',
        'Build/unity_webgl.wasm',
      ];

      for (final filePath in filesToCopy) {
        try {
          final byteData = await rootBundle.load('assets/unity_webgl/$filePath');
          final file = File('${unityDir.path}/$filePath');
          await file.create(recursive: true);
          await file.writeAsBytes(byteData.buffer.asUint8List(
            byteData.offsetInBytes,
            byteData.lengthInBytes,
          ));
        } catch (e) {
          print('コピー失敗 ($filePath): $e');
        }
      }
    }

    return unityDir.path;
  }

  // 2. ローカルサーバーを起動する関数
  Future<void> start(String rootPath) async {
    if (_server != null) return;

    final staticHandler =
        createStaticHandler(rootPath, defaultDocument: 'index.html');

    final handler = const shelf.Pipeline()
        .addMiddleware(shelf.logRequests())
        .addHandler(staticHandler);

    _server = await shelf_io.serve(handler, 'localhost', port);
  }

  // 3. サーバーを停止する関数
  Future<void> stop() async {
    await _server?.close();
    _server = null;
  }
}