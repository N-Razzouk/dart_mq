import 'package:dart_mq/dart_mq.dart';
import 'package:dart_mq/src/core/exceptions/exceptions.dart';
import 'package:dart_mq/src/exchange/direct_exchange.dart';
import 'package:dart_mq/src/queue/queue.dart';
import 'package:test/test.dart';

void main() {
  late DirectExchange directExchange;
  late Queue queue1;
  late Queue queue2;
  late Message message;

  setUp(() {
    directExchange = DirectExchange('my_direct_exchange');
    queue1 = Queue('queue_1');
    queue2 = Queue('queue_2');
    message = Message(
      headers: {'contentType': 'json', 'sender': 'Alice'},
      payload: {'text': 'Hello, World!'},
      timestamp: '2023-09-07T12:00:002',
    );
  });

  test('bindQueue binds a queue to the direct exchange with a binding key', () {
    directExchange.bindQueue(queue: queue1, bindingKey: 'routing_key_1');
    expect(directExchange.bindings.has('routing_key_1'), isTrue);
  });

  test(
      'bindQueue binds a queue to the direct exchange with a binding key that '
      'already exists.', () {
    directExchange
      ..bindQueue(queue: queue1, bindingKey: 'routing_key_1')
      ..bindQueue(queue: queue2, bindingKey: 'routing_key_1');
    expect(directExchange.bindings.has('routing_key_1'), isTrue);
  });

  test(
      'unbindQueue unbinds a queue from the direct exchange with a binding key',
      () {
    directExchange
      ..bindQueue(queue: queue1, bindingKey: 'routing_key_1')
      ..unbindQueue(queueId: queue1.id, bindingKey: 'routing_key_1');
    expect(directExchange.bindings.has('routing_key_1'), isFalse);
  });

  test(
      'forwardMessage forwards a message to the direct exchange using a '
      'routing key', () {
    directExchange
      ..bindQueue(queue: queue1, bindingKey: 'routing_key_1')
      ..forwardMessage(message: message, routingKey: 'routing_key_1');
    expect(queue1.latestMessage, equals(message));
  });

  test(
      'forwardMessage throws BindingKeyNotFoundException when routing key is '
      'not found', () {
    expect(
      () => directExchange.forwardMessage(
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
      () => directExchange.forwardMessage(message: message),
      throwsA(isA<RoutingKeyRequiredException>()),
    );
  });

  test(
      'unbindQueue throws BindingKeyNotFoundException when attempting to '
      'unbind with an invalid binding key', () {
    expect(
      () => directExchange.unbindQueue(
        queueId: 'queue_id',
        bindingKey: 'invalid_binding_key',
      ),
      throwsA(isA<BindingKeyNotFoundException>()),
    );
  });
}
