import 'package:dart_mq/dart_mq.dart';
import 'package:dart_mq/src/binding/binding.dart';
import 'package:dart_mq/src/core/exceptions/queue_exceptions.dart';
import 'package:dart_mq/src/queue/queue.dart';
import 'package:test/test.dart';

void main() {
  late Binding binding;
  late Queue queue1;
  late Queue queue2;

  setUp(() {
    binding = Binding('my_binding');
    queue1 = Queue('queue_1');
    queue2 = Queue('queue_2');
  });

  test('addQueue adds a queue to the binding', () {
    binding.addQueue(queue1);
    expect(binding.hasQueues(), isTrue);
  });

  test('removeQueue removes a queue from the binding', () {
    binding.addQueue(queue1);
    expect(binding.hasQueues(), isTrue);

    binding.removeQueue('queue_1');
    expect(binding.hasQueues(), isFalse);
  });

  test(
      'removeQueue throws QueueHasSubscribersException if queue has '
      'subscribers', () {
    final sub = queue1.dataStream.listen((_) {});

    binding.addQueue(queue1);

    expect(
      () => binding.removeQueue('queue_1'),
      throwsA(isA<QueueHasSubscribersException>()),
    );

    sub.cancel();
  });

  test('publishMessage publishes a message to all associated queues', () {
    binding
      ..addQueue(queue1)
      ..addQueue(queue2);

    final message = Message(
      headers: {'contentType': 'json', 'sender': 'Alice'},
      payload: {'text': 'Hello, World!'},
      timestamp: '2023-09-07T12:00:002',
    );

    binding.publishMessage(message);

    expect(queue1.latestMessage, equals(message));
    expect(queue2.latestMessage, equals(message));
  });

  test('hasQueues returns true if the binding has associated queues', () {
    expect(binding.hasQueues(), isFalse);

    binding.addQueue(queue1);
    expect(binding.hasQueues(), isTrue);
  });

  test('clear clears all queues from the binding', () {
    binding
      ..addQueue(queue1)
      ..addQueue(queue2);

    expect(binding.hasQueues(), isTrue);

    binding.clear();
    expect(binding.hasQueues(), isFalse);
  });

  test('clear throws QueueHasSubscribersException if a queue has subscribers',
      () {
    final sub = queue1.dataStream.listen((_) {});

    binding
      ..addQueue(queue1)
      ..addQueue(queue2);

    expect(binding.hasQueues(), isTrue);

    expect(() => binding.clear(), throwsA(isA<QueueHasSubscribersException>()));

    expect(binding.hasQueues(), isTrue);

    sub.cancel();
  });
}
