import 'dart:async';

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
  log.debug('debug');
  log.info('info');
  log.warn('warning');
  log.error('error');
  log.fatal('fatal');
  final expected = [
    'trace',
    'debug',
    'info',
    'warning',
    'error',
    'fatal',
  ];
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
  test('Severity levels', () async {
    expect(Level.trace.severityLevel, equals(300));
    expect(Level.debug.severityLevel, equals(600));
    expect(Level.info.severityLevel, equals(900));
    expect(Level.warn.severityLevel, equals(1200));
    expect(Level.error.severityLevel, equals(1500));
    expect(Level.fatal.severityLevel, equals(1800));
  });
  test('The LogRecord', () async {
    final record = LogRecord('test', name: 'name');
    // Skip time
    expect(record.toString().split(' - ')[1], equals('[name] test'));
  });
}
