import 'package:de_log/de_log.dart';

/// The record data.
///
/// This class contains the log [level] and the [record].
class RecordData<T> {
  /// The log level.
  Level level;

  /// The record.
  T record;

  /// Creates [RecordData] that uses given [level] and [record] parameters.
  RecordData(this.level, this.record);
}
