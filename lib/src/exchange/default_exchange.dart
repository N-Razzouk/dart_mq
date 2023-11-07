import 'package:dart_mq/src/binding/binding.dart';
import 'package:dart_mq/src/core/exceptions/exceptions.dart';
import 'package:dart_mq/src/exchange/exchange.base.dart';
import 'package:dart_mq/src/exchange/exchange_interface.dart';
import 'package:dart_mq/src/message/message.dart';
import 'package:dart_mq/src/queue/queue.dart';

/// A class representing the default message exchange for message routing.
///
/// The `DefaultExchange` class is a specific implementation of the
/// `BaseExchange` abstract base class, representing the default exchange.
/// It provides functionality for binding queues, forwarding messages based on
/// routing keys, and preventing unbinding from the default exchange.
///
/// Example:
/// ```dart
/// final defaultExchange = DefaultExchange('default_exchange');
///
/// // Bind a queue to the default exchange.
/// final queue = Queue('my_queue');
/// defaultExchange.bindQueue(queue: queue, bindingKey: 'my_routing_key');
///
/// // Forward a message to the default exchange using a routing key.
/// final message = Message(
///   headers: {'contentType': 'json', 'sender': 'Alice'},
///   payload: {'text': 'Hello, World!'},
///   timestamp: '2023-09-07T12:00:002',
/// );
/// defaultExchange.forwardMessage(message, routingKey: 'my_routing_key');
/// ```
final class DefaultExchange extends BaseExchange implements ExchangeInterface {
  /// Creates a new instance of the default exchange with the specified [id].
  ///
  /// The [id] parameter represents the unique identifier for the default
  /// exchange.
  DefaultExchange(super.id);

  @override
  void bindQueue({
    required Queue queue,
    required String bindingKey,
  }) =>
      (bindings.has(bindingKey)
          ? bindings.get(bindingKey)
          : _registerAndGetBinding(bindingKey))
        ..addQueue(queue);

  Binding _registerAndGetBinding(String bindingKey) {
    bindings.register(bindingKey, Binding(bindingKey));
    return bindings.get(bindingKey);
  }

  @override
  void unbindQueue({
    required String queueId,
    required String bindingKey,
  }) {
    (bindings.has(bindingKey)
            ? bindings.get(bindingKey)
            : throw BindingKeyNotFoundException(bindingKey))
        .removeQueue(queueId);

    if (!bindings.get(bindingKey).hasQueues()) {
      bindings.unregister(bindingKey);
    }
  }

  @override
  void forwardMessage({
    required Message message,
    String? routingKey,
  }) =>
      (bindings.has(
        routingKey ?? (throw RoutingKeyRequiredException()),
      )
              ? bindings.get(routingKey)
              : throw BindingKeyNotFoundException(routingKey))
          .publishMessage(message);

  @override
  void deleteQueue(String queueId) {
    for (final binding in bindings.getAll()) {
      binding.removeQueue(queueId);
    }
  }
}
