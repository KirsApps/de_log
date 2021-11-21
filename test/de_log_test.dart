import 'package:data_queue/data_queue.dart';
import 'package:de_log/de_log.dart';
import 'package:test/test.dart';

class BufferHandler<T> extends LogHandler<T> {
  bool isDisposed = false;
  final List<T> buffer = [];

  @override
  Future<void> dispose() async {
    isDisposed = true;
  }

  @override
  void handle(RecordData<T> data) {
    buffer.add(data.record);
  }
}

class BufferQueueHandler<T> extends QueueLogHandler<T> {
  bool isDisposed = false;
  final List<T> buffer = [];
  @override
  Future<void> handleRecords() async {
    try {
      final data = await worker.next;
      buffer.add(data.record);
      handleRecords();
    } on TerminatedException {
      isDisposed = true;
    }
  }
}

void main() {
  final bufferQueueHandler = BufferQueueHandler<String>();
  final bufferHandler = BufferHandler<String>();
  final log = DeLog<String>([bufferHandler, bufferQueueHandler]);
  log.trace('trace');
  log.fatal('fatal');
  log.error('error');
  log.warn('warning');
  final expected = ['trace', 'fatal', 'error', 'warning'];
  test('log buffer', () {
    expect(bufferHandler.buffer, equals(expected));
  });
  test('log buffer queue', () {
    expect(bufferQueueHandler.buffer, equals(expected));
  });
  test('log dispose', () async {
    await log.dispose();
    expect(bufferHandler.isDisposed, equals(true));
    expect(bufferQueueHandler.isDisposed, equals(true));
  });
}
