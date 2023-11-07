import 'package:dart_mq/src/queue/data_stream.base.dart';
import 'package:equatable/equatable.dart';

/// A class representing a queue for message streaming.
///
/// The `Queue` class extends the [BaseDataStream] class and adds an
/// identifier, making it suitable for managing and streaming messages in a
/// queue-like fashion.
///
/// Example:
/// ```dart
/// final myQueue = Queue('my_queue_id');
///
/// // Enqueue a message to the queue.
/// final message = Message(
///   headers: {'contentType': 'json', 'sender': 'Alice'},
///   payload: {'text': 'Hello, World!'},
///   timestamp: '2023-09-07T12:00:002',
/// );
/// myQueue.enqueue(message);
///
/// // Check if the queue has active listeners.
/// final hasListeners = myQueue.hasListeners();
/// ```
class Queue extends BaseDataStream with EquatableMixin {
  /// Creates a new queue with the specified [id].
  ///
  /// The [id] parameter is a unique identifier for the queue.
  Queue(this.id);

  /// The unique identifier for the queue.
  final String id;

  @override
  List<Object?> get props => [id];
}
