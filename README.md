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

# キャラクター演出名一覧 (character1_effect)

Storyデータの `character1_effect` で使用する演出エフェクト名一覧です。登場演出（`_in`）および退場演出（`_out`）を同じカラムで指定します。

| No | 演出名 | 登場演出コード | 退場演出コード | 概要 |
| :--- | :--- | :--- | :--- | :--- |
| 1 | フェード | `fade_in` | `fade_out` | アルファ値（透明度）の変化でスムーズに表示/非表示 |
| 2 | 下スライド | `slide_up_in` | `slide_down_out` | 下から浮き上がるように登場 / 下へ退場 |
| 3 | 横スライド | `slide_left_in` / `slide_right_in` | `slide_left_out` / `slide_right_out` | 画面左右から移動して登場 / 退場 |
| 4 | ズーム | `zoom_in` | `zoom_out` | 拡大しながら手前に登場 / 縮小退場 |
| 5 | ブラー | `blur_in` | `blur_out` | ぼかし状態からピントが合って登場 / ぼやけて退場 |
| - | 演出なし | `none` | `none` | 演出なし（即時表示/非表示） |