/// The levels for logging output.
enum Level {
  /// The trace level.
  trace,

  /// The debug level.
  debug,

  /// The info level.
  info,

  /// The warning level.
  warn,

  /// The error level.
  error,

  /// The fatal level.
  fatal,
}

/// The extension contains the method for getting the severity level.
extension SeverityLevel on Level {
  /// Returns the severity level that describes this.
  int get severityLevel => ((index + 1) * 3) * 100;
}
