import 'package:de_log/de_log.dart';

/// The logger class.
///
/// For this class use, you need to specify the type
/// that will be used as the record and pass [handlers].
class DeLog<T> {
  /// The list with log handlers.
  final List<LogHandler<T>> _handlers;

  /// Creates the [RecordData] that uses the given [handlers] parameter.
  DeLog(List<LogHandler<T>> handlers) : _handlers = handlers;

  /// Log a record at level [Level.trace].
  void trace(T record) => log(Level.trace, record);

  /// Log a record at level [Level.debug].
  void debug(T record) => log(Level.debug, record);

  /// Log a record at level [Level.info].
  void info(T record) => log(Level.info, record);

  /// Log a record at level [Level.warn].
  void warn(T record) => log(Level.warn, record);

  /// Log a record at level [Level.error].
  void error(T record) => log(Level.error, record);

  /// Log a record at level [Level.fatal].
  void fatal(T record) => log(Level.fatal, record);

  /// Log a [record] at the [level].
  void log(Level level, T record) {
    for (final handler in _handlers) {
      handler.handle(RecordData(level, record));
    }
  }

  /// Disposes of all logger handlers.
  Future<void> dispose() => Future.wait(_handlers.map((e) => e.dispose()));
}
