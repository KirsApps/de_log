import 'package:de_log/de_log.dart';

/// The logger class.
///
/// For this class use, you need to specify the type
/// that will be used as the record and pass [LogHandler]'s.
class DeLog<T> {
  /// The list with log handlers.
  final List<LogHandler<T>> _handlers;

  DeLog(List<LogHandler<T>> handlers) : _handlers = handlers;

  /// Logs message at level [Level.trace].
  void trace(T record) => log(Level.trace, record);

  /// Logs message at level [Level.debug].
  void debug(T record) => log(Level.debug, record);

  /// Logs message at level [Level.info].
  void info(T record) => log(Level.info, record);

  /// Logs message at level [Level.warn].
  void warn(T record) => log(Level.warn, record);

  /// Logs message at level [Level.error].
  void error(T record) => log(Level.error, record);

  /// Logs message at level [Level.fatal].
  void fatal(T record) => log(Level.fatal, record);

  void log(Level level, T record) {
    for (final handler in _handlers) {
      handler.handle(RecordData(level, record));
    }
  }
}
