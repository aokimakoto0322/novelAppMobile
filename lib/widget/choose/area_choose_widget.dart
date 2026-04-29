import 'package:flutter/material.dart';

class AreaChooseWidget extends StatefulWidget {
  const AreaChooseWidget({super.key});

  @override
  State<AreaChooseWidget> createState() => _AreaChooseWidgetState();
}

class _AreaChooseWidgetState extends State<AreaChooseWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _buttonController;
  late final Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _buttonAnimation = Tween<double>(begin: 0.0, end: -10.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('images/background/school_sample.png', fit: BoxFit.cover),
        ),
        Align(
          alignment: const Alignment(0.0, 0.7),
          child: _buildPyokoButton(),
        ),
      ],
    );
  }

  Widget _buildPyokoButton() {
    return Container(
      // ボタンの外側の影など（装飾）
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orangeAccent, // ボタンの色
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          elevation: 0, // Containerの影を使うため、こちらは0に
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // 丸いボタン
          ),
        ),
        onPressed: () {
          // ボタンが押されたときの処理
          print("場所を決定しました！");
        },
        // ★ここがポイント： AnimatedBuilderで中身だけを動かす
        child: AnimatedBuilder(
          animation: _buttonAnimation,
          builder: (context, child) {
            // Tweenで定義した値 (0.0 ～ -10.0) をY軸の移動量に適用
            return Transform.translate(
              offset: Offset(0, _buttonAnimation.value),
              child: child, // 実際の中身（下のRow）
            );
          },
          // 動かしたい中身（アイコンとテキスト）
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, size: 28), // 場所のアイコン
              SizedBox(width: 10),
              Text(
                '冒険を始める！',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}