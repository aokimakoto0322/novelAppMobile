import 'package:flutter/material.dart';

class WillPopScopeDialogWidget extends StatelessWidget {
  final Widget child;

  const WillPopScopeDialogWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('確認'),
              content: const Text('この画面を閉じますか？'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('キャンセル'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('OK'),
                ),
              ],
            ),
          );

          if ((shouldExit ?? false) && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: child,
    );
  }
}