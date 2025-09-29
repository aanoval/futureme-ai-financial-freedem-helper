// Dokumen: Validator untuk form input seperti umur, keuangan di FutureMe.
String? validateName(String? value) {
  if (value == null || value.isEmpty) return 'Nama tidak boleh kosong';
  return null;
}

String? validateAge(String? value) {
  if (value == null || int.tryParse(value) == null || int.parse(value) < 18) return 'Umur minimal 18 tahun';
  return null;
}

String? validateAmount(String? value) {
  if (value == null || double.tryParse(value) == null || double.parse(value) <= 0) return 'Jumlah harus positif';
  return null;
}

String? validateTargetAge(String? value, int currentAge) {
  final age = int.tryParse(value ?? '');
  if (age == null || age <= currentAge) return 'Target umur harus lebih dari umur saat ini';
  return null;
}