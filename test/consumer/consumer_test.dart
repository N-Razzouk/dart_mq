import 'package:dart_mq/src/consumer/consumer.dart';
import 'package:dart_mq/src/core/exceptions/exceptions.dart';
import 'package:dart_mq/src/message/message.dart';
import 'package:dart_mq/src/mq/mq.dart';
import 'package:test/test.dart';

class MyMessageConsumer with Consumer {
  // Custom implementation of the message consumer.
}

void main() {
  group('Consumer', () {
    final consumer = MyMessageConsumer();
    setUpAll(() {
      MQClient.initialize();

      MQClient.instance.declareQueue('test-queue');
    });

    test('subscribe should register a subscription and receive messages',
        () async {
      const queueId = 'test-queue';
      final message1 = Message(payload: 'Message 1');
      final message2 = Message(payload: 'Message 2');
      final callbackMessages = <Message>[];

      consumer.subscribe(
        queueId: queueId,
        callback: (message) {
          callbackMessages.add(message);
        },
      );

      // Publish messages to the queue
      MQClient.instance.sendMessage(
        exchangeName: '',
        message: message1,
        routingKey: queueId,
      );
      MQClient.instance.sendMessage(
        exchangeName: '',
        message: message2,
        routingKey: queueId,
      );

      await Future.delayed(Duration.zero);

      // Ensure that the callback was called with the expected messages
      expect(callbackMessages, contains(message1));
      expect(callbackMessages, contains(message2));
    });

    test('unsubscribe should cancel a subscription', () async {
      const queueId = 'test-queue';
      final message1 = Message(payload: 'Message 1');
      final message2 = Message(payload: 'Message 2');
      final callbackMessages = <Message>[];

      consumer
        ..clearSubscriptions()
        ..subscribe(
          queueId: queueId,
          callback: (message) {
            callbackMessages.add(message);
          },
        );

      // Publish messages to the queue
      MQClient.instance.sendMessage(
        exchangeName: '',
        message: message1,
        routingKey: queueId,
      );

      await Future.delayed(Duration.zero);

      // Unsubscribe and ensure that the callback is not called
      consumer.unsubscribe(queueId: queueId);

      // Publish messages to the queue
      MQClient.instance.sendMessage(
        exchangeName: '',
        message: message2,
        routingKey: queueId,
      );

      expect(callbackMessages, contains(message1));
      expect(callbackMessages.length, equals(1));
    });

    test('pauseSubscription should pause a subscription', () async {
      const queueId = 'test-queue';
      final message1 = Message(payload: 'Message 1');
      final message2 = Message(payload: 'Message 2');
      final callbackMessages = <Message>[];

      consumer
        ..clearSubscriptions()
        ..subscribe(
          queueId: queueId,
          callback: (message) {
            callbackMessages.add(message);
          },
        );

      // Publish messages to the queue
      MQClient.instance.sendMessage(
        exchangeName: '',
        message: message1,
        routingKey: queueId,
      );

      await Future.delayed(Duration.zero);

      // Pause the subscription and ensure that the callback is not called
      consumer.pauseSubscription(queueId);

      // Publish messages to the queue
      MQClient.instance.sendMessage(
        exchangeName: '',
        message: message2,
        routingKey: queueId,
      );

      expect(callbackMessages, contains(message1));
      expect(callbackMessages.length, equals(1));
    });

    test('resumeSubscription should resume a paused subscription', () async {
      const queueId = 'test-queue';
      final message1 = Message(payload: 'Message 1');
      final message2 = Message(payload: 'Message 2');
      final callbackMessages = <Message>[];

      consumer
        ..clearSubscriptions()
        ..subscribe(
          queueId: queueId,
          callback: (message) {
            callbackMessages.add(message);
          },
        );

      // Publish a message to the queue
      MQClient.instance.sendMessage(
        exchangeName: '',
        message: message1,
        routingKey: queueId,
      );

      // Pause and then resume the subscription and ensure that the callback is
      // called.
      consumer
        ..pauseSubscription(queueId)
        ..resumeSubscription(queueId);
      MQClient.instance.sendMessage(
        exchangeName: '',
        message: message2,
        routingKey: queueId,
      );

      await Future.delayed(Duration.zero);

      expect(callbackMessages, contains(message1));
      expect(callbackMessages, contains(message2));
      expect(callbackMessages.length, equals(2));
    });

    test(
        'updateSubscription should update a subscription with a new callback '
        'and filter', () async {
      const queueId = 'test-queue';
      final message1 = Message(payload: 'Message 1');
      final message2 = Message(payload: 'Message 2');
      final message3 = Message(payload: 'Message 3');
      final callbackMessages = <Message>[];

      consumer
        ..clearSubscriptions()
        ..subscribe(
          queueId: queueId,
          callback: (message) {
            callbackMessages.add(message);
          },
        );

      // Publish messages to the queue
      MQClient.instance.sendMessage(
        exchangeName: '',
        message: message1,
        routingKey: queueId,
      );
      MQClient.instance.sendMessage(
        exchangeName: '',
        message: message2,
        routingKey: queueId,
      );

      await Future.delayed(Duration.zero);
      // Update the subscription with a new callback and filter
      consumer.updateSubscription(
        queueId: queueId,
        callback: (message) {
          if (message.payload == 'Message 2') {
            callbackMessages.add(message);
          }
        },
        filter: (payload) => payload == 'Message 2',
      );

      // Publish another message to the queue
      MQClient.instance.sendMessage(
        exchangeName: '',
        message: message3,
        routingKey: queueId,
      );
      MQClient.instance.sendMessage(
        exchangeName: '',
        message: message2,
        routingKey: queueId,
      );

      await Future.delayed(Duration.zero);

      // Ensure that the callback is only called with 'Message 2'
      expect(callbackMessages, contains(message1));
      expect(callbackMessages, contains(message2));
      expect(callbackMessages.contains(message3), isFalse);
      expect(callbackMessages.length, equals(3));
    });

    test('clearSubscriptions should clear all subscriptions', () async {
      const queueId = 'test-queue';
      final message1 = Message(payload: 'Message 1');
      final message2 = Message(payload: 'Message 2');
      final message3 = Message(payload: 'Message 3');
      final callbackMessages = <Message>[];

      consumer
        ..clearSubscriptions()
        ..subscribe(
          queueId: queueId,
          callback: (message) {
            callbackMessages.add(message);
          },
        );

      // Publish messages to the queue
      MQClient.instance.sendMessage(
        exchangeName: '',
        message: message1,
        routingKey: queueId,
      );
      MQClient.instance.sendMessage(
        exchangeName: '',
        message: message2,
        routingKey: queueId,
      );

      await Future.delayed(Duration.zero);
      // Update the subscription with a new callback and filter
      consumer.clearSubscriptions();

      // Publish another message to the queue
      MQClient.instance.sendMessage(
        exchangeName: '',
        message: message3,
        routingKey: queueId,
      );

      await Future.delayed(Duration.zero);

      // Ensure that the callback is only called on the first two messages.
      expect(callbackMessages, contains(message1));
      expect(callbackMessages, contains(message2));
      expect(callbackMessages.contains(message3), isFalse);
      expect(callbackMessages.length, equals(2));
    });

    test('getLatestMessage should return the latest message from a queue',
        () async {
      const queueId = 'test-queue';
      final message1 = Message(payload: 'Message 1');
      final message2 = Message(payload: 'Message 2');
      final message3 = Message(payload: 'Message 3');

      consumer
        ..clearSubscriptions()
        ..subscribe(
          queueId: queueId,
          callback: (_) {},
        );

      // Publish messages to the queue
      MQClient.instance.sendMessage(
        exchangeName: '',
        message: message1,
        routingKey: queueId,
      );
      MQClient.instance.sendMessage(
        exchangeName: '',
        message: message2,
        routingKey: queueId,
      );
      MQClient.instance.sendMessage(
        exchangeName: '',
        message: message3,
        routingKey: queueId,
      );

      await Future.delayed(Duration.zero);

      // Get the latest message
      final latestMessage = consumer.getLatestMessage(queueId);

      // Ensure that the latest message is 'Message 3'
      expect(latestMessage, equals(message3));
    });

    test(
        'subscribing to a queue that has already been subscribed to throws an '
        'error.', () {
      const queueId = 'test-queue';

      consumer
        ..clearSubscriptions()
        ..subscribe(queueId: queueId, callback: (_) {});

      expect(
        () => consumer.subscribe(queueId: queueId, callback: (_) {}),
        throwsA(isA<ConsumerAlreadySubscribedException>()),
      );
    });
  });
}
