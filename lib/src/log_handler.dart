import 'package:data_queue/data_queue.dart';
import 'package:de_log/de_log.dart';
import 'package:meta/meta.dart';

/// The abstract log handler class.
abstract class LogHandler<T> {
  /// Handles the given [data] that is passing by the [DeLog].
  void handle(RecordData<T> data);

  /// Frees resources that this handler use.
  Future<void> dispose();
}

/// The queue log handler. Records add to the queue
/// and will be available with the [QueueWorker] asynchronous
/// in the [handleRecords] method.
abstract class QueueLogHandler<T> extends LogHandler<T> {
  /// Creates the [QueueLogHandler] that runs the [handleRecords] method.
  QueueLogHandler() {
    handleRecords();
  }

  /// The [QueueWorker].
  @protected
  final worker = QueueWorker<RecordData<T>>(DataQueue<RecordData<T>>());

  @override
  void handle(RecordData<T> data) => worker.add(data);

  @override
  @mustCallSuper
  Future<void> dispose() async => worker.terminate();

  /// Handles records that will be available asynchronous through the [QueueWorker].
  Future<void> handleRecords();
}
