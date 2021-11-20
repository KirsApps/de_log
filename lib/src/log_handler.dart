import 'package:data_queue/data_queue.dart';
import 'package:de_log/de_log.dart';
import 'package:meta/meta.dart';

/// The abstract log handler class.
abstract class LogHandler<T> {
  /// Handles given [data].
  void handle(RecordData<T> data);

  /// Frees resources that this handler use.
  Future<void> dispose();
}

/// The queue log handler. Records add to the queue
/// and will be available with [QueueWorker] asynchronous
/// in the [handleRecords] method.
abstract class QueueLogHandler<T> extends LogHandler<T> {
  /// The queueWorker.
  final _worker = QueueWorker<RecordData<T>>(DataQueue<RecordData<T>>());

  @override
  void handle(RecordData<T> data) => _worker.add(data);

  @override
  @mustCallSuper
  Future<void> dispose() async => _worker.terminate();

  /// Handles records that will be available asynchronous through [QueueWorker].
  Future<void> handleRecords();
}
