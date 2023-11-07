import 'package:dart_mq/src/message/message.dart';
import 'package:dart_mq/src/queue/queue.dart';

/// An abstract interface class defining the contract for managing exchanges.
///
/// The `ExchangeInterface` defines a contract for classes that are responsible
/// for managing exchanges. Implementing classes must provide functionality for
/// binding queues to the exchange, unbinding queues from the exchange,
/// forwarding messages to queues or bindings, and removing queues from all
/// associated bindings.
///
///  Example:
/// ```dart
/// class MyExchange implements ExchangeInterface {
///  // Custom implementation of the exchange.
/// }
/// ```
abstract interface class ExchangeInterface {
  /// Binds a queue to the exchange with a specific binding key.
  ///
  /// The [queue] parameter represents the queue to be bound to the exchange.
  /// The [bindingKey] parameter represents the binding key for the queue.
  void bindQueue({
    required Queue queue,
    required String bindingKey,
  });

  /// Unbinds a queue from the exchange based on its ID and binding key.
  ///
  /// The [queueId] parameter represents the ID of the queue to be unbound.
  /// The [bindingKey] parameter represents the binding key for the queue.
  void unbindQueue({
    required String queueId,
    required String bindingKey,
  });

  /// Forwards a message to queues or bindings based on the routing key.
  ///
  /// The [message] parameter represents the message to be forwarded.
  /// The [routingKey] parameter represents the optional routing key to
  /// determine the destination queues or bindings.
  void forwardMessage({
    required Message message,
    String? routingKey,
  });

  /// Removes a queue from all associated bindings.
  ///
  /// The [queueId] parameter represents the ID of the queue to be removed.
  void deleteQueue(String queueId);
}
