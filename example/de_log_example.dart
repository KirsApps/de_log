import 'package:data_queue/data_queue.dart';
import 'package:de_log/de_log.dart';

class QueueAsyncHandler<T> extends QueueLogHandler<T> {
  @override
  Future<void> handleRecords() async {
    try {
      // Here we get one record from the queue when it is available.
      // You can use other commands from the QueueWorker class.
      // For example:
      // worker.take(4) - take 4 records
      // ignore: unused_local_variable
      final data = await worker.next;
      // handle records

      // Here we call this method again for waiting for new records.
      await handleRecords();
    } on TerminatedException {
      // logger was disposed
    }
  }
}

class PrintHandler<T> extends LogHandler<T> {
  @override
  void handle(RecordData data) {
    //ignore:avoid_print
    print(data.record);
  }

  @override
  Future<void> dispose() async {}
}

void main() {
  final log = DeLog<String>([QueueAsyncHandler(), PrintHandler()]);

  // log fatal message
  log.fatal('fatal');

  // log trace message
  log.trace('trace');
}
