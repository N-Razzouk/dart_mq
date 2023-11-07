import 'package:dart_mq/dart_mq.dart';
import 'package:dart_mq/src/core/exceptions/exceptions.dart';
import 'package:test/test.dart';

void main() {
  group('Initialization', () {
    test(
        'MQClient instance should throw MQClientNotInitializedException if '
        'not initialized', () {
      expect(
        () => MQClient.instance,
        throwsA(isA<MQClientNotInitializedException>()),
      );
    });

    test('MQClient initialize should create a singleton instance', () {
      MQClient.initialize();
      final initializedInstance = MQClient.instance;
      expect(initializedInstance, isA<MQClient>());
      expect(MQClient.instance, equals(initializedInstance));
    });
  });

  group('Queue Operations', () {
    setUpAll(MQClient.initialize);

    test('listQueues should return a list of all registered queues', () {
      final queueId = MQClient.instance.declareQueue('test-queue');
      final queues = MQClient.instance.listQueues();
      expect(queues, isA<List<String>>());
      expect(queues, contains(queueId));
      MQClient.instance.deleteQueue(queueId);
    });
    test(
        'declareQueue should declare a new queue and bind it to the default '
        'exchange', () {
      final queueId = MQClient.instance.declareQueue('test-queue');
      final queue = MQClient.instance.fetchQueue(queueId);
      expect(queue, isNotNull);
      MQClient.instance.deleteQueue(queueId);
    });

    test('declareQueue should declare a new queue with the specified name', () {
      final queueId = MQClient.instance.declareQueue('test-queue');
      final queue = MQClient.instance.fetchQueue(queueId);
      expect(queue, isNotNull);
      expect(MQClient.instance.fetchQueue(queueId), isA<Stream<Message>>());
      MQClient.instance.deleteQueue(queueId);
    });

    test(
        "declareQueue should return name of queue even if it's already "
        'registered', () {
      final queueId = MQClient.instance.declareQueue('test-queue');

      final queueId2 = MQClient.instance.declareQueue('test-queue');

      expect(queueId, equals(queueId2));

      MQClient.instance.deleteQueue(queueId);
    });

    test(
        'fetchQueue should throw QueueNotRegisteredException if the queue does '
        'not exist.', () {
      expect(
        () => MQClient.instance.fetchQueue('test-queue'),
        throwsA(isA<QueueNotRegisteredException>()),
      );
    });

    test(
        'getLatestMessage should throw QueueNotRegisteredException if the '
        'queue does not exist.', () {
      expect(
        () => MQClient.instance.getLatestMessage('test-queue'),
        throwsA(isA<QueueNotRegisteredException>()),
      );
    });

    test('deleteQueue should delete a queue', () {
      final queueId = MQClient.instance.declareQueue('test-queue');
      MQClient.instance.deleteQueue(queueId);
      expect(
        () => MQClient.instance.fetchQueue(queueId),
        throwsA(isA<QueueNotRegisteredException>()),
      );
    });

    test(
        'deleteQueue should throw QueueNotRegisteredException if the queue '
        'does not exist.', () {
      expect(
        () => MQClient.instance.deleteQueue('test-queue'),
        throwsA(isA<QueueNotRegisteredException>()),
      );
    });

    test(
        'deleteQueue should throw QueueHasSubscribersException if there are '
        'any consumers consuming that queue.', () {
      final queueId = MQClient.instance.declareQueue('test-queue');
      final queueStream = MQClient.instance.fetchQueue(queueId);
      final sub = queueStream.listen((_) {});

      expect(
        () => MQClient.instance.deleteQueue(queueId),
        throwsA(isA<QueueHasSubscribersException>()),
      );

      sub.cancel();
      MQClient.instance.deleteQueue(queueId);
    });
  });

  group('Exchange Operations', () {
    setUpAll(() => MQClient);
    setUp(() {
      MQClient.initialize();
    });
    test('declareExchange should declare a new exchange of the specified type',
        () {
      final queueId = MQClient.instance.declareQueue('test-queue');
      const exchangeName = 'exchange';
      MQClient.instance.declareExchange(
        exchangeName: exchangeName,
        exchangeType: ExchangeType.direct,
      );

      MQClient.instance.bindQueue(
        queueId: queueId,
        exchangeName: exchangeName,
        bindingKey: 'test-binding',
      );

      MQClient.instance.sendMessage(
        message: Message(payload: 'test'),
        exchangeName: exchangeName,
        routingKey: 'test-binding',
      );

      expect(
        MQClient.instance.getLatestMessage(queueId)?.payload,
        equals('test'),
      );

      MQClient.instance.deleteExchange(exchangeName);
      MQClient.instance.deleteQueue(queueId);
    });

    test(
        'sendMessage to unregister exchange should throw '
        'ExchangeNotRegisteredException', () {
      const exchangeName = 'exchange';
      expect(
        () => MQClient.instance.sendMessage(
          message: Message(payload: 'test'),
          exchangeName: exchangeName,
          routingKey: 'test-binding',
        ),
        throwsA(isA<ExchangeNotRegisteredException>()),
      );
    });

    test(
        'declareExchange should throw InvalidExchangeTypeException if the '
        'exchange type is invalid', () {
      const exchangeName = 'exchange';
      expect(
        () => MQClient.instance.declareExchange(
          exchangeName: exchangeName,
          exchangeType: ExchangeType.base,
        ),
        throwsA(isA<InvalidExchangeTypeException>()),
      );
      MQClient.instance.deleteExchange(exchangeName);
    });

    test('deleteExchange should delete an exchange', () {
      const exchangeName = 'exchange';
      expect(
        () => MQClient.instance.bindQueue(
          queueId: 'test-queue',
          exchangeName: exchangeName,
        ),
        throwsA(isA<ExchangeNotRegisteredException>()),
      );
    });

    test('deleteExchange should do nothing if the exchange does not exist', () {
      expect(
        () => MQClient.instance.deleteExchange('nonexistent_exchange'),
        returnsNormally,
      );
    });

    test('bindQueue should bind a queue to direct exchange', () {
      final queueId = MQClient.instance.declareQueue('test-queue');
      const exchangeName = 'exchange';
      MQClient.instance.declareExchange(
        exchangeName: exchangeName,
        exchangeType: ExchangeType.direct,
      );
      MQClient.instance.bindQueue(
        queueId: queueId,
        exchangeName: exchangeName,
        bindingKey: 'key',
      );

      MQClient.instance.deleteQueue(queueId);
      MQClient.instance.deleteExchange(exchangeName);
    });

    test('bindQueue should bind a queue to fanout exchange', () {
      final queueId = MQClient.instance.declareQueue('test-queue');
      const exchangeName = 'exchange';
      MQClient.instance.declareExchange(
        exchangeName: exchangeName,
        exchangeType: ExchangeType.fanout,
      );
      MQClient.instance.bindQueue(queueId: queueId, exchangeName: exchangeName);

      MQClient.instance.deleteQueue(queueId);
      MQClient.instance.deleteExchange(exchangeName);
    });

    test(
        'bindQueue should throw BindingKeyRequiredException if bindingKey is '
        'not provided for DirectExchange', () {
      final queueId = MQClient.instance.declareQueue('test-queue');
      const exchangeName = 'exchange';
      MQClient.instance.declareExchange(
        exchangeName: exchangeName,
        exchangeType: ExchangeType.direct,
      );
      expect(
        () => MQClient.instance.bindQueue(
          queueId: queueId,
          exchangeName: exchangeName,
        ),
        throwsA(isA<BindingKeyRequiredException>()),
      );

      MQClient.instance.deleteQueue(queueId);
      MQClient.instance.deleteExchange(exchangeName);
    });

    test('unbindQueue should unbind a queue from an exchange', () {
      final queueId = MQClient.instance.declareQueue('test-queue');
      const exchangeName = 'exchange';
      MQClient.instance.declareExchange(
        exchangeName: exchangeName,
        exchangeType: ExchangeType.direct,
      );
      expect(
        () => MQClient.instance.bindQueue(
          queueId: queueId,
          exchangeName: exchangeName,
          bindingKey: 'test-binding-key',
        ),
        returnsNormally,
      );
      MQClient.instance.unbindQueue(
        queueId: queueId,
        exchangeName: exchangeName,
        bindingKey: 'test-binding-key',
      );
      MQClient.instance.deleteQueue(queueId);
      MQClient.instance.deleteExchange(exchangeName);
    });

    test(
        'unbindQueue should throw BindingKeyRequiredException if '
        'bindingKey is not provided for DirectExchange', () {
      final queueId = MQClient.instance.declareQueue('test-queue');
      const exchangeName = 'exchange';
      MQClient.instance.declareExchange(
        exchangeName: exchangeName,
        exchangeType: ExchangeType.direct,
      );
      expect(
        () => MQClient.instance.unbindQueue(
          queueId: queueId,
          exchangeName: exchangeName,
        ),
        throwsA(isA<BindingKeyRequiredException>()),
      );

      MQClient.instance.deleteQueue(queueId);
      MQClient.instance.deleteExchange(exchangeName);
    });
    test(
        'unbindQueue should not throw BindingKeyRequiredException if '
        'bindingKey is not provided for FanoutExchange', () {
      final queueId = MQClient.instance.declareQueue('test-queue');
      const exchangeName = 'exchange';
      MQClient.instance.declareExchange(
        exchangeName: exchangeName,
        exchangeType: ExchangeType.fanout,
      );
      expect(
        () => MQClient.instance
            .unbindQueue(queueId: queueId, exchangeName: exchangeName),
        returnsNormally,
      );

      MQClient.instance.deleteQueue(queueId);
      MQClient.instance.deleteExchange(exchangeName);
    });

    test(
        'unbindQueue should throw ExchangeNotRegisteredException '
        'if exchange does not exist', () {
      final queueId = MQClient.instance.declareQueue('test-queue');
      const exchangeName = 'exchange';
      expect(
        () => MQClient.instance.unbindQueue(
          queueId: queueId,
          exchangeName: exchangeName,
        ),
        throwsA(isA<ExchangeNotRegisteredException>()),
      );

      MQClient.instance.deleteQueue(queueId);
    });
  });

  group('Close Operations.', () {
    setUpAll(() => MQClient);
    setUp(() {
      MQClient.initialize();
    });
    test('close should close the MQClient', () {
      MQClient.instance.declareQueue('test-queue');
      MQClient.instance.close();
      expect(
        () => MQClient.instance,
        throwsA(isA<MQClientNotInitializedException>()),
      );
    });
  });
}
