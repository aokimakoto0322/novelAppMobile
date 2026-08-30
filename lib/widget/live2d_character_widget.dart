import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../usecase/unity_server_manager.dart';

class Live2DCharacterWidget extends StatefulWidget {
  const Live2DCharacterWidget({super.key});

  @override
  State<Live2DCharacterWidget> createState() => _Live2DCharacterWidgetState();
}

class _Live2DCharacterWidgetState extends State<Live2DCharacterWidget> {
  WebViewController? _controller;
  final UnityServerManager _serverManager = UnityServerManager();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initServerAndWebView();
  }

  Future<String?> _loadUnityContent() async {
    try {
      // 1. アセットをローカルストレージに展開
      final unityDirPath = await _serverManager.prepareUnityFiles();

      // 2. ローカルサーバーを起動
      await _serverManager.start(unityDirPath);

      return unityDirPath;
    } catch (e) {
      print('Unity初期化エラー: $e');
      return null;
    }
  }

  Future<void> _initServerAndWebView() async {
    final unityDirPath = await _loadUnityContent();
    if (unityDirPath == null || !mounted) return;

    // 3. WebViewのコントローラーを設定（localhost経由でindex.htmlをロード）
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..loadRequest(Uri.parse('http://localhost:8080/index.html'));

    setState(() {
      _controller = controller;
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _serverManager.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return const SizedBox.shrink(); // 準備中は何も表示しない
    }

    // タップイベントを後ろに通すためIgnorePointerで囲む
    return IgnorePointer(
      child: WebViewWidget(controller: _controller!),
    );
  }
}