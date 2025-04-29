class Choose1 {
  final int id;
  final String sortId;
  final int visibleStoryId;
  final String select1;
  final String select2;
  final String select3;
  final String select4;
  final String select5;

  Choose1({
    required this.id,
    required this.sortId,
    required this.visibleStoryId,
    required this.select1,
    required this.select2,
    required this.select3,
    required this.select4,
    required this.select5
  });

  // データベースから取得したMapデータをモデルに変換
  factory Choose1.fromMap(Map<String, dynamic> map) {
    return Choose1(
      id: map['id'],
      sortId: map['sort_id'],
      visibleStoryId: map['visible_story_id'],
      select1: map['select_1'],
      select2: map['select_2'],
      select3: map['select_3'],
      select4: map['select_4'],
      select5: map['select_5']
    );
  }
  // APIから取得したJsonをモデルに変換
  factory Choose1.fromJson(Map<String, dynamic> json) {
    return Choose1(
      id: int.parse(json['id']),
      sortId: json['sort_id'],
      visibleStoryId: int.parse(json['visible_story_id']),
      select1: json['select_1'],
      select2: json['select_2'],
      select3: json['select_3'],
      select4: json['select_4'],
      select5: json['select_5']
    );
  }
}