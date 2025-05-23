class CommonStory {
  final int storyId;
  final String sortId;
  final String word;

  CommonStory(
    {
      required this.storyId,
      required this.sortId,
      required this.word
    }
  );

  // データベースから取得したMapデータをモデルに変換
  factory CommonStory.fromMap(Map<String, dynamic> map) {
    return CommonStory(
      storyId: map['story_id'],
      sortId: map['sort_id'],
      word: map['word']
    );
  }
  // APIから取得したJsonをモデルに変換
  factory CommonStory.fromJson(Map<String, dynamic> json) {
    return CommonStory(
      storyId: int.parse(json['story_id']),
      sortId: json['sort_id'],
      word: json['word']
    );
  }

  // List<CommonStory>型からList<Map<String, dynamic>>型に変換
  Map<String, dynamic> toMap() {
    return {
      'story_id': storyId,
      'sort_id': sortId.toString(),
      'word': word
    };
  }
}