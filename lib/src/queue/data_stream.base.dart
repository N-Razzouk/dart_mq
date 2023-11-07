import 'dart:async';

import 'package:dart_mq/src/message/message.dart';

/// An abstract base class for data streams that produce [Message] objects.
///
/// The `BaseDataStream` class provides the foundation for creating data
/// streams that emit [Message] objects to their listeners. It includes a
/// [StreamController] to manage the stream of messages and methods to enqueue
/// messages and dispose of the stream when it's no longer needed.
///
/// Example:
/// ```dart
/// class MyDataStream extends BaseDataStream {
///   // Custom methods and logic specific to your data stream can be added here.
/// }
/// ```
abstract class BaseDataStream {
  /// A [StreamController] for broadcasting [Message] objects to listeners.
  final StreamController<Message> _data = StreamController.broadcast();

  /// Returns a [Stream] of [Message] objects from this data stream.
  Stream<Message> get dataStream => _data.stream;

  /// The latest [Message] enqueued in the data stream.
  ///
  /// This property keeps track of the most recently enqueued message.
  Message? _latestMessage;

  /// Exposes the [_latestMessage] property.
  ///
  /// This getter returns the most recently enqueued message.
  Message? get latestMessage => _latestMessage;

  /// Enqueues a [Message] to be emitted by the data stream.
  ///
  /// The [message] parameter represents the [Message] to enqueue, and it
  /// becomes the latest message in the stream.
  void enqueue(Message message) {
    _latestMessage = message;
    _data.add(message);
  }

  /// Closes the data stream, freeing up resources.
  ///
  /// This method should be called when the data stream is no longer needed
  /// to prevent resource leaks.
  void dispose() => _data.close();

  /// Checks if there are any active listeners on the data stream.
  ///
  /// Returns `true` if there are active listeners, and `false` otherwise.
  bool hasListeners() => _data.hasListener;
}
