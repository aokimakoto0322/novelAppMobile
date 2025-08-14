# flutter_nobel_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Driftのビルド
`flutter pub run build_runner build`


# MEMO
## 子Widgetでcontextで受け取るか、引数で渡すかの判断

1. このWidgetはビジネスロジックに依存しているか？  
   → Yes → 引数で受け取る  
   → No → 次へ  

2. このWidgetは再利用されるか？  
   → Yes → 引数で受け取る  
   → No → 次へ  

3. このWidgetはテスト対象か？  
   → Yes → 引数で受け取る  
   → No → context.read() でもOK  