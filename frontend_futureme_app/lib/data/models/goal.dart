// Model for goal tracking stored in SQLite.
class Goal {
  int? id;
  String description;
  DateTime targetDate;
  double targetAmount;
  double currentProgress;
  bool isAchieved;

  Goal({
    this.id,
    required this.description,
    required this.targetDate,
    required this.targetAmount,
    this.currentProgress = 0.0,
    this.isAchieved = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'targetDate': targetDate.toIso8601String(),
      'targetAmount': targetAmount,
      'currentProgress': currentProgress,
      'isAchieved': isAchieved ? 1 : 0,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      description: map['description'],
      targetDate: DateTime.parse(map['targetDate']),
      targetAmount: map['targetAmount'],
      currentProgress: map['currentProgress'],
      isAchieved: map['isAchieved'] == 1,
    );
  }
}