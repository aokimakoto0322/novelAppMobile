class Save {
  final int id;
  final int storyId;
  final String saveDate;

  Save(
    {
      required this.id,
      required this.storyId,
      required this.saveDate
    }
  );

  // データベースから取得したMapデータをモデルに変換
  factory Save.fromMap(Map<String, dynamic> map) {
    return Save(
      id: map['id'],
      storyId: map['story_id'],
      saveDate: map['save_date']
    );
  }
}