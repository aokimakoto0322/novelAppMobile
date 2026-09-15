## 概念図
![概念図](flow.png)


## CI/CD
### CD
- GitHub Actionsによる自動デプロイ
   - developブランチにマージされた瞬間にTestFlightに自動デプロイ

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

# Unityのビルド
1. Unity -> File -> Build Setting -> WebGL -> Buildをする
2. できたフォルダを/assets内に入れ替える

# memo
- Unity初期化したら、下記をやること
   - Window -> PackageManager -> InputSystemをいれること（入れないとSDKが動作しない）

# シナリオデータの自動化
[ Googleスプレッドシート ]
   └▶「デプロイ実行」ボタンをワンクリック！  
         │. 
         ├─ ①＆② GoogleドキュメントをHTML変換して指定フォルダに保存
         ├─ ③ 先ほどのロジックでHTML解析 ＆ Sheet2の演出データをマージしてSheet1更新
         ├─ ④ Sheet1のデータをCSV形式に変換
         └─ ⑤ AWS S3バケットへ直接PUTアップロード
               │
               ▼ (S3のObjectCreatedイベントを検知)
[ AWS S3 ] ───▶ [ AWS Lambda ]
                     ├─ ⑥ DynamoDBの既存データをクリア
                     └─ ⑦ S3のCSVを読み込んでDynamoDBへPutItem