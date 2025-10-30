import 'dart:async';

Future<T> retryWithBackoff<T>(
  Future<T> Function() action, {
  int maxRetries = 3,
  Duration initialDelay = const Duration(seconds: 1),
  Duration? maxDelay,
  void Function(int attempt, Exception? error)? onRetry,
}) async {
  int attempt = 0;
  Duration delay = initialDelay;
  Exception? lastError;

  while (attempt < maxRetries) {
    try {
      return await action();
    } catch (e) {
      lastError = e is Exception ? e : Exception(e.toString());
      attempt++;
      // Print debug info for each attempt
      print('[retryWithBackoff] Attempt $attempt failed: $lastError');
      if (onRetry != null) onRetry(attempt, lastError);
      if (attempt < maxRetries) {
        await Future.delayed(delay);
        delay = Duration(seconds: delay.inSeconds * 2);
        if (maxDelay != null && delay > maxDelay) delay = maxDelay;
      }
    }
  }
  print('[retryWithBackoff] Max retries ($maxRetries) reached. Throwing last error.');
  throw lastError ?? Exception('Unknown error after $maxRetries attempts');
}
