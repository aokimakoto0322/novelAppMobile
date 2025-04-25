class SaveViewModel {
  final int id;
  final int storyId;
  final String saveDate;
  final String word;

  SaveViewModel(
    {
      required this.id,
      required this.storyId,
      required this.saveDate,
      required this.word
    }
  );

  // データベースから取得したMapデータをモデルに変換
  factory SaveViewModel.fromMap(Map<String, dynamic> map) {
    return SaveViewModel(
      id: map['id'],
      storyId: map['story_id'],
      saveDate: map['save_date'],
      word: map['word']
    );
  }
}