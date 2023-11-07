import 'package:dart_mq/src/message/message.dart';

/// An abstract interface class defining the contract for a message consumer.
///
/// The `ConsumerInterface` abstract interface class defines a contract for
/// classes that implement a message consumer. Implementing classes must
/// provide methods for subscribing and unsubscribing from queues, pausing and
/// resuming subscriptions, updating subscriptions, retrieving the
/// latest message from a queue, and clearing all subscriptions.
///
/// Example:
/// ```dart
/// class MyConsumer implements ConsumerInterface {
///   // Custom implementation of the message consumer.
/// }
/// ```
abstract interface class ConsumerInterface {
  /// Subscribes to a queue to receive messages.
  ///
  /// The [queueId] parameter represents the ID of the queue to subscribe to.
  /// The [callback] parameter is a function that will be invoked for each
  /// received message.
  /// The [filter] parameter is an optional function that can be used to filter
  /// messages based on custom criteria.
  void subscribe({
    required String queueId,
    required Function(Message) callback,
    bool Function(Object)? filter,
  });

  /// Unsubscribes from a previously subscribed queue.
  ///
  /// The [queueId] parameter represents the ID of the queue to unsubscribe
  /// from.
  void unsubscribe({required String queueId});

  /// Pauses message subscription for a specified queue.
  ///
  /// The [queueId] parameter represents the ID of the queue to pause the
  /// subscription.
  void pauseSubscription(String queueId);

  /// Resumes a paused subscription for a specified queue.
  ///
  /// The [queueId] parameter represents the ID of the queue to resume the
  /// subscription.
  void resumeSubscription(String queueId);

  /// Updates an existing subscription with a new callback and/or filter.
  ///
  /// The [queueId] parameter represents the ID of the queue to update the
  /// subscription.
  /// The [callback] parameter is a new function that will be invoked for each
  /// received message.
  /// The [filter] parameter is an optional new filter function for message
  /// filtering.
  void updateSubscription({
    required String queueId,
    required Function(Message) callback,
    bool Function(Object)? filter,
  });

  /// Retrieves the latest message from a queue.
  ///
  /// The [queueId] parameter represents the ID of the queue to fetch the latest
  /// message from.
  ///
  /// Returns the latest message from the specified queue or `null` if the queue
  /// is empty.
  Message? getLatestMessage(String queueId);

  /// Clears all active subscriptions, unsubscribing from all queues.
  void clearSubscriptions();
}
