import 'package:dart_mq/dart_mq.dart';
import 'package:dart_mq/src/core/exceptions/exceptions.dart';
import 'package:dart_mq/src/exchange/default_exchange.dart';
import 'package:dart_mq/src/queue/queue.dart';
import 'package:test/test.dart';

void main() {
  late DefaultExchange defaultExchange;
  late Queue queue;
  late Message message;

  setUp(() {
    defaultExchange = DefaultExchange('default_exchange');
    queue = Queue('my_queue');
    message = Message(
      headers: {'contentType': 'json', 'sender': 'Alice'},
      payload: {'text': 'Hello, World!'},
      timestamp: '2023-09-07T12:00:002',
    );
  });

  test('bindQueue binds a queue to the default exchange with a binding key',
      () {
    defaultExchange.bindQueue(queue: queue, bindingKey: 'my_routing_key');
    expect(defaultExchange.bindings.has('my_routing_key'), isTrue);
  });

  test(
      'unbindQueue throws an exception when attempting to unbind from the '
      'default exchange', () {
    expect(
      () => defaultExchange.unbindQueue(
        queueId: 'my_queue_id',
        bindingKey: 'my_routing_key',
      ),
      throwsA(isA<BindingKeyNotFoundException>()),
    );
  });

  test('unbindQueue unbinds a queue from the default exchange', () {
    defaultExchange
      ..bindQueue(queue: queue, bindingKey: 'my_routing_key')
      ..unbindQueue(
        queueId: queue.id,
        bindingKey: 'my_routing_key',
      );
    expect(defaultExchange.bindings.has('my_routing_key'), isFalse);
  });

  test(
      'forwardMessage forwards a message to the default exchange using a '
      'routing key', () {
    defaultExchange
      ..bindQueue(queue: queue, bindingKey: 'my_routing_key')
      ..forwardMessage(message: message, routingKey: 'my_routing_key');
    expect(queue.latestMessage, equals(message));
  });

  test(
      'forwardMessage throws BindingKeyNotFoundException when routing key is '
      'not found', () {
    expect(
      () => defaultExchange.forwardMessage(
        message: message,
        routingKey: 'non_existent_routing_key',
      ),
      throwsA(isA<BindingKeyNotFoundException>()),
    );
  });

  test(
      'forwardMessage throws RoutingKeyRequiredException when routing key is '
      'null', () {
    expect(
      () => defaultExchange.forwardMessage(message: message),
      throwsA(isA<RoutingKeyRequiredException>()),
    );
  });
}
