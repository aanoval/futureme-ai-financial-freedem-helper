// Model for mood entries stored in SQLite.
class MoodEntry {
  int? id;
  String mood; // 'senang', 'sedih', etc.
  DateTime date;
  String note;
  String? aiSuggestion;

  MoodEntry({
    this.id,
    required this.mood,
    required this.date,
    this.note = '',
    this.aiSuggestion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood': mood,
      'date': date.toIso8601String(),
      'note': note,
      'aiSuggestion': aiSuggestion,
    };
  }

  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id'],
      mood: map['mood'],
      date: DateTime.parse(map['date']),
      note: map['note'],
      aiSuggestion: map['aiSuggestion'],
    );
  }
}