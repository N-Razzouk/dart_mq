import 'package:dart_mq/src/binding/binding.interface.dart';
import 'package:dart_mq/src/core/exceptions/exceptions.dart';
import 'package:dart_mq/src/message/message.dart';
import 'package:dart_mq/src/queue/queue.dart';

/// A class representing a binding between a topic and its associated queues.
///
/// The `Binding` class implements the [BindingInterface] interface and is
/// responsible for managing the association between a topic and its associated
/// queues. It allows the addition and removal of queues to the binding and the
/// publication of messages to all associated queues.
///
/// Example:
/// ```dart
/// final binding = Binding('my_binding');
/// final queue1 = Queue('queue_1');
/// final queue2 = Queue('queue_2');
///
/// // Add queues to the binding.
/// binding.addQueue(queue1);
/// binding.addQueue(queue2);
///
/// // Publish a message to all associated queues.
/// final message = Message(
///   headers: {'contentType': 'json', 'sender': 'Alice'},
///   payload: {'text': 'Hello, World!'},
///   timestamp: '2023-09-07T12:00:002',
/// );
/// binding.publishMessage(message);
///
/// // Check if the binding has associated queues.
/// final hasQueues = binding.hasQueues(); // Returns true
/// ```
final class Binding implements BindingInterface {
  /// Creates a new binding with the specified [id].
  ///
  /// The [id] parameter represents the unique identifier for the binding.
  Binding(this.id);

  /// The unique identifier for the binding.
  final String id;

  /// A list of associated queues.
  final List<Queue> _queues = [];

  @override
  bool hasQueues() => _queues.isNotEmpty;

  @override
  void addQueue(Queue queue) => _queues.add(queue);

  @override
  void removeQueue(String queueId) => _queues.removeWhere(
        (Queue queue) => queue.id == queueId && queue.hasListeners()
            ? throw QueueHasSubscribersException(queueId)
            : queue.id == queueId,
      );

  @override
  void publishMessage(Message message) {
    for (final queue in _queues) {
      queue.enqueue(message);
    }
  }

  @override
  void clear() {
    for (final queue in _queues) {
      if (queue.hasListeners()) {
        throw QueueHasSubscribersException(queue.id);
      }
    }
    _queues.clear();
  }
}
