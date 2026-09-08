import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../usecase/unity_server_manager.dart';

class Live2DState {
  final WebViewController? controller;
  final bool isInitialized;
  final bool isLoading;
  final bool isUnityLoaded;
  final bool isUnitySplashFinished;

  Live2DState({
    this.controller,
    this.isInitialized = false,
    this.isLoading = false,
    this.isUnityLoaded = false,
    this.isUnitySplashFinished = false,
  });

  Live2DState copyWith({
    WebViewController? controller,
    bool? isInitialized,
    bool? isLoading,
    bool? isUnityLoaded,
    bool? isUnitySplashFinished,
  }) {
    return Live2DState(
      controller: controller ?? this.controller,
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      isUnityLoaded: isUnityLoaded ?? this.isUnityLoaded,
      isUnitySplashFinished:
          isUnitySplashFinished ?? this.isUnitySplashFinished,
    );
  }
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

  void showCanvas() {
    state.controller?.runJavaScript(
        'var c = document.getElementById("unity-canvas"); if(c) c.style.visibility = "visible";');
  }

  void hideCanvas() {
    state.controller?.runJavaScript(
        'var c = document.getElementById("unity-canvas"); if(c) c.style.visibility = "hidden";');
  }

  /// Unity側へBGM再生命令を送信する
  void playBgm(String bgmName) {
    if (bgmName.isEmpty) {
      stopBgm();
      return;
    }
    state.controller?.runJavaScript('playBgm("$bgmName");');
  }

  /// Unity側へBGM停止命令を送信する
  void stopBgm() {
    state.controller?.runJavaScript('stopBgm();');
  }

  Future<void> _initServerAndWebView() async {
    try {
      final unityDirPath = await _serverManager.prepareUnityFiles();
      await _serverManager.start(unityDirPath);

      late final PlatformWebViewControllerCreationParams params;
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }

      final controller = WebViewController.fromPlatformCreationParams(params)
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptChannel(
          'FlutterChannel',
          onMessageReceived: (JavaScriptMessage message) {
            if (message.message == 'unity_loaded') {
              state = state.copyWith(isUnityLoaded: true);
            } else if (message.message == 'unity_splash_finished') {
              state = state.copyWith(isUnitySplashFinished: true);
            }
          },
        )
        ..loadRequest(Uri.parse('http://localhost:8080/index.html'));

      state = Live2DState(
        controller: controller,
        isInitialized: true,
        isLoading: false,
        isUnityLoaded: false,
        isUnitySplashFinished: false,
      );
    } catch (e) {
      debugPrint('Unity初期化エラー: $e');
      state = Live2DState(
        isInitialized: false,
        isLoading: false,
        isUnityLoaded: false,
        isUnitySplashFinished: false,
      );
    }
  }
}

final live2dProvider =
    NotifierProvider<Live2DNotifier, Live2DState>(Live2DNotifier.new);

