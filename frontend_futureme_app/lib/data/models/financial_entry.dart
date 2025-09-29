// Model for financial entries stored in SQLite.
class FinancialEntry {
  int? id;
  double amount;
  String type; // 'pemasukan' or 'pengeluaran'
  String? photoUrl; // Local path from image_picker
  DateTime date;
  String? description;

  FinancialEntry({
    this.id,
    required this.amount,
    required this.type,
    this.photoUrl,
    required this.date,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'photoUrl': photoUrl,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory FinancialEntry.fromMap(Map<String, dynamic> map) {
    return FinancialEntry(
      id: map['id'],
      amount: map['amount'],
      type: map['type'],
      photoUrl: map['photoUrl'],
      date: DateTime.parse(map['date']),
      description: map['description'],
    );
  }
}