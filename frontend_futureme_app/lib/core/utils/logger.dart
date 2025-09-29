// Dokumen: Logger sederhana untuk debugging dan production logging di FutureMe.
import 'package:flutter/foundation.dart';

void logInfo(String message) {
  if (kDebugMode) {
    print('FutureMe INFO: $message');
  } // Integrasikan dengan Sentry atau Firebase untuk production.
}

void logError(String message, [Object? error]) {
  if (kDebugMode) {
    print('FutureMe ERROR: $message ${error ?? ''}');
  } // Kirim ke server di production.
}