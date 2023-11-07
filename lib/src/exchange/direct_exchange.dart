import 'package:dart_mq/src/binding/binding.dart';
import 'package:dart_mq/src/core/exceptions/exceptions.dart';
import 'package:dart_mq/src/exchange/exchange.base.dart';
import 'package:dart_mq/src/exchange/exchange_interface.dart';
import 'package:dart_mq/src/message/message.dart';
import 'package:dart_mq/src/queue/queue.dart';

/// A class representing a direct message exchange for message routing.
///
/// The `DirectExchange` class is a specific implementation of the
/// `BaseExchange` abstract base class, representing a direct exchange. A
/// direct exchange routes messages to queues based on matching routing keys.
/// It provides functionality for binding queues, forwarding messages based on
/// routing keys, and unbinding queues from the direct exchange.
///
/// Example:
/// ```dart
/// final directExchange = DirectExchange('my_direct_exchange');
///
/// // Bind queues to the direct exchange with different routing keys.
/// final queue1 = Queue('queue_1');
/// final queue2 = Queue('queue_2');
/// directExchange.bindQueue(queue: queue1, bindingKey: 'routing_key_1');
/// directExchange.bindQueue(queue: queue2, bindingKey: 'routing_key_2');
///
/// // Forward a message with a matching routing key to the appropriate queue.
/// final message = Message(
///   headers: {'contentType': 'json', 'sender': 'Alice'},
///   payload: {'text': 'Hello, World!'},
///   timestamp: '2023-09-07T12:00:002',
/// );
/// directExchange.forwardMessage(message, routingKey: 'routing_key_1');
/// ```
final class DirectExchange extends BaseExchange implements ExchangeInterface {
  /// Creates a new instance of the direct exchange with the specified [id].
  ///
  /// The [id] parameter represents the unique identifier for the direct
  /// exchange.
  DirectExchange(super.id);

  @override
  void bindQueue({
    required Queue queue,
    required String bindingKey,
  }) =>
      (bindings.has(bindingKey)
              ? bindings.get(bindingKey)
              : _registerAndGetBinding(bindingKey))
          .addQueue(queue);

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
