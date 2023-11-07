import 'package:dart_mq/src/exchange/fanout_exchange.dart';
import 'package:dart_mq/src/message/message.dart';
import 'package:dart_mq/src/queue/queue.dart';
import 'package:test/test.dart';

void main() {
  group('FanoutExchange', () {
    test('bindQueue should add a queue to the exchange', () {
      final fanoutExchange = FanoutExchange('my_fanout_exchange');
      final queue1 = Queue('queue_1');
      final queue2 = Queue('queue_2');

      fanoutExchange
        ..bindQueue(queue: queue1, bindingKey: 'binding_key_1')
        ..bindQueue(queue: queue2, bindingKey: 'binding_key_2');

      expect(fanoutExchange.bindings.get('').hasQueues(), isTrue);
    });

    test('unbindQueue should remove a queue from the exchange', () {
      final fanoutExchange = FanoutExchange('my_fanout_exchange');
      final queue1 = Queue('queue_1');
      final queue2 = Queue('queue_2');

      fanoutExchange
        ..bindQueue(queue: queue1, bindingKey: 'binding_key_1')
        ..bindQueue(queue: queue2, bindingKey: 'binding_key_2')
        ..unbindQueue(queueId: 'queue_1', bindingKey: 'binding_key_1')
        ..unbindQueue(queueId: 'queue_2', bindingKey: 'binding_key_2');

      expect(fanoutExchange.bindings.get('').hasQueues(), isFalse);
    });

    test('forwardMessage should forward a message to all associated queues',
        () {
      final fanoutExchange = FanoutExchange('my_fanout_exchange');
      final queue1 = Queue('queue_1');
      final queue2 = Queue('queue_2');

      fanoutExchange
        ..bindQueue(queue: queue1, bindingKey: 'binding_key_1')
        ..bindQueue(queue: queue2, bindingKey: 'binding_key_2');

      final message = Message(
        headers: {'contentType': 'json', 'sender': 'Alice'},
        payload: {'text': 'Hello, World!'},
        timestamp: '2023-09-07T12:00:002',
      );

      fanoutExchange.forwardMessage(message: message);

      expect(queue1.latestMessage, equals(message));
      expect(queue2.latestMessage, equals(message));
    });

    test('removeQueue removes a queue from all bindings', () {
      final queue1 = Queue('queue_1');

      final fanoutExchange = FanoutExchange('my_fanout_exchange')
        ..bindQueue(queue: queue1, bindingKey: '')
        ..unbindQueue(
          queueId: queue1.id,
          bindingKey: '',
        );

      expect(fanoutExchange.bindings.get('').hasQueues(), isFalse);
    });
  });
}
