import 'package:dart_mq/src/message/message.dart';
import 'package:dart_mq/src/queue/queue.dart';

/// An abstract interface class defining the contract for managing bindings.
///
/// The `BindingInterface` abstract interface class defines a contract for
/// classes that are responsible for managing bindings between topics and
/// queues. Implementing classes must provide functionality for adding and
/// removing queues from the binding, publishing messages to the associated
/// queues, and checking if the binding has queues.
///
/// Example:
/// ```dart
/// class MyBinding implements BindingInterface {
///   // Custom implementation of the binding interface methods.
/// }
/// ```
abstract interface class BindingInterface {
  /// Checks if the binding has associated queues.
  ///
  /// Returns `true` if the binding has one or more associated queues;
  /// otherwise, `false`.
  bool hasQueues();

  /// Adds a queue to the binding.
  ///
  /// The [queue] parameter represents the queue to be associated with the
  /// binding.
  void addQueue(Queue queue);

  /// Removes a queue from the binding based on its ID.
  ///
  /// The [queueId] parameter represents the ID of the queue to be removed.
  void removeQueue(String queueId);

  /// Publishes a message to all associated queues in the binding.
  ///
  /// The [message] parameter represents the message to be published to the
  /// queues.
  void publishMessage(Message message);

  /// Removes all queues from the binding.
  void clear();
}
