import 'dart:async';

/// The log record data
class LogRecord {
  /// The log message
  final String message;

  /// The time when this record was created.
  final DateTime time;

  /// A monotonically increasing sequence number.
  final int sequenceNumber;

  /// The name of the source of the log message
  final String name;

  /// The zone where the log was emitted.
  final Zone? zone;

  /// An error object associated with this log event.
  final Object? error;

  /// A stack trace associated with this log event
  final StackTrace? stackTrace;

  static int _nextNumber = 0;

  /// Creates the [LogRecord] that uses given parameters.
  LogRecord(
    this.message, {
    this.name = '',
    this.error,
    StackTrace? stackTrace,
    Zone? zone,
  })  : stackTrace = stackTrace ?? StackTrace.current,
        zone = zone ?? Zone.current,
        time = DateTime.now(),
        sequenceNumber = LogRecord._nextNumber++;

  @override
  String toString() => '$time - [$name] $message';
}
