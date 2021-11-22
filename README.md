<p align="center">
<img src="https://raw.githubusercontent.com/KirsApps/de_log/master/assets/logo.png" height="350" alt="DeLog" />
</p>

[![codecov](https://codecov.io/gh/KirsApps/de_log/branch/master/graph/badge.svg)](https://codecov.io/gh/KirsApps/de_log)
[![Build Status](https://github.com/KirsApps/de_log/workflows/build/badge.svg)](https://github.com/KirsApps/de_log/actions?query=workflow%3A"build"+branch%3Amaster)
[![pub](https://img.shields.io/pub/v/de_log.svg)](https://pub.dev/packages/de_log)
[![style: lint](https://img.shields.io/badge/style-lint-4BC0F5.svg)](https://pub.dev/packages/lint)

The declarative logger allows you to create your own records and records handlers.

## Usage

To use this logger, you must create your own record and pass the type to the logger.
Also, you need to create handlers for this record and pass them to the logger constructor.

```dart
/// The record class.
class SimpleStringMessage {
  String message;
  String? description;
  SimpleStringMessage(this.message, this.description);
}

/// The handler that prints all records.
class PrintHandler<T> extends LogHandler<T> {
  @override
  void handle(RecordData data) {
    print(data.record);
  }

  @override
  Future<void> dispose() async {}
}

final log = DeLog<SimpleStringMessage>([PrintHandler()]);

/// log fatal message
log.fatal('fatal');

/// log trace message
log.trace('trace');
```

## Handlers

Handlers need to perform actions on received records, for example, print, store, send them through a network, etc.
There are two classes for handlers:

* LogHandler - The base class that handles records synchronously.
* QueueLogHandler - The base class that handles records asynchronous in the queue.

You can see the example usage of these handlers in de_log_example.dart.

## Dispose


You can dispose of the logger. When you call the dispose method, it disposes of all handlers.
All futures in QueueLogHandler descendants will throw the TerminatedException. It is good practice wrapping your code in the try block with on TerminatedException clause. 
When you catch the TerminatedException, you know that the logger was disposed of and perform resources cleanup.

```dart
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
```