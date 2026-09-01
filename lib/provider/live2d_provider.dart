import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../usecase/unity_server_manager.dart';

class Live2DState {
  final WebViewController? controller;
  final bool isInitialized;
  final bool isLoading;

  Live2DState({
    this.controller,
    this.isInitialized = false,
    this.isLoading = false,
  });
}

class Live2DNotifier extends Notifier<Live2DState> {
  final UnityServerManager _serverManager = UnityServerManager();

  @override
  Live2DState build() {
    _initServerAndWebView();
    ref.onDispose(() {
      _serverManager.stop();
    });
    return Live2DState(isLoading: true);
  }

  Future<void> _initServerAndWebView() async {
    try {
      final unityDirPath = await _serverManager.prepareUnityFiles();
      await _serverManager.start(unityDirPath);

      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse('http://localhost:8080/index.html'));

      state = Live2DState(
        controller: controller,
        isInitialized: true,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('Unity初期化エラー: $e');
      state = Live2DState(isInitialized: false, isLoading: false);
    }
  }
}

final live2dProvider =
    NotifierProvider<Live2DNotifier, Live2DState>(Live2DNotifier.new);

