import 'package:dart_mq/src/binding/binding.dart';
import 'package:dart_mq/src/exchange/exchange.base.dart';
import 'package:dart_mq/src/exchange/exchange_interface.dart';
import 'package:dart_mq/src/message/message.dart';
import 'package:dart_mq/src/queue/queue.dart';

/// A class representing a fanout message exchange for message routing.
///
/// The `FanoutExchange` class is a specific implementation of the
/// `BaseExchange` abstract base class, representing a fanout exchange.
/// A fanout exchange routes messages to all associated queues without
/// considering routing keys. It provides functionality for binding queues,
/// forwarding messages to all associated queues, and unbinding queues
/// from the fanout exchange.
///
/// Example:
/// ```dart
/// final fanoutExchange = FanoutExchange('my_fanout_exchange');
///
/// // Bind multiple queues to the fanout exchange.
/// final queue1 = Queue('queue_1');
/// final queue2 = Queue('queue_2');
/// fanoutExchange.bindQueue(queue: queue1, bindingKey: 'binding_key_1');
/// fanoutExchange.bindQueue(queue: queue2, bindingKey: 'binding_key_2');
///
/// // Forward a message to all associated queues in the fanout exchange.
/// final message = Message(
///   headers: {'contentType': 'json', 'sender': 'Alice'},
///   payload: {'text': 'Hello, World!'},
///   timestamp: '2023-09-07T12:00:002',
/// );
/// fanoutExchange.forwardMessage(message);
/// ```
final class FanoutExchange extends BaseExchange implements ExchangeInterface {
  /// Creates a new instance of the fanout exchange with the specified [id].
  ///
  /// The [id] parameter represents the unique identifier for the fanout
  /// exchange.
  FanoutExchange(super.id) {
    bindings.register('', Binding(''));
  }

  @override
  void bindQueue({
    required Queue queue,
    required String bindingKey,
  }) =>
      bindings.get('').addQueue(queue);

  @override
  void unbindQueue({
    required String queueId,
    required String bindingKey,
  }) =>
      bindings.get('').removeQueue(queueId);

  @override
  void forwardMessage({
    required Message message,
    String? routingKey,
  }) =>
      bindings.get('').publishMessage(message);

  @override
  void deleteQueue(String queueId) {
    for (final binding in bindings.getAll()) {
      binding.removeQueue(queueId);
    }
  }
}
