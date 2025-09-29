// Dokumen: Fungsi helper umum untuk aplikasi FutureMe, termasuk format data keuangan dan tanggal.
import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(amount);
}

String formatDate(DateTime date) {
  return DateFormat('dd MMM yyyy', 'id_ID').format(date);
}

double calculateProgress(double current, double target) {
  return current / target.clamp(0.0, double.infinity);
}

// Helper untuk animasi: Durasi standar.
const Duration animationDuration = Duration(milliseconds: 300);

// Fungsi untuk hitung usia target kebebasan finansial.
int calculateYearsToFreedom(int currentAge, int targetAge) {
  return targetAge - currentAge;
}