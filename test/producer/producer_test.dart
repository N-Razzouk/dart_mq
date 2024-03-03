import 'dart:async';
import 'package:dart_mq/dart_mq.dart';
import 'package:test/test.dart';

class MyMessageProducer with ProducerMixin {
  // Custom implementation of the message producer.
}

void main() {
  group('Producer', () {
    final producer = MyMessageProducer();

    setUpAll(() {
      MQClient.initialize();

      MQClient.instance.declareQueue('test-queue');
    });

    test(
        'sendMessage should send a message to an exchange and call the '
        'callback', () {
      final message = Message(
        payload: 'Test Message',
        timestamp: '2023-09-07T12:00:002',
      );
      var callbackCalled = false;
      producer
        ..setPushCallback((message) {
          callbackCalled = true;
        })
        ..sendMessage(
          payload: 'Test Message',
          exchangeName: '',
          routingKey: 'test-queue',
          timestamp: '2023-09-07T12:00:002',
        );

      expect(
        MQClient.instance.getLatestMessage('test-queue')?.headers,
        equals(message.headers),
      );
      expect(
        MQClient.instance.getLatestMessage('test-queue')?.payload,
        equals(message.payload),
      );
      expect(
        MQClient.instance.getLatestMessage('test-queue')?.timestamp,
        equals(message.timestamp),
      );
      expect(callbackCalled, isTrue);
    });

    test(
        'sendRPCMessage should send an RPC message to an exchange and call the '
        'callback', () async {
      var callbackCalled = false;

      producer.setPushCallback((message) {
        callbackCalled = true;
      });

      final sub = MQClient.instance.fetchQueue('test-queue').listen((message) {
        if (message.headers['type'] == 'RPC') {
          (message.headers['completer'] as Completer).complete('Response');
          return;
        }
      });

      final res = await producer.sendRPCMessage(
        processId: 'foo',
        args: {'key': 'value'},
        exchangeName: '',
        routingKey: 'test-queue',
      );

      expect(callbackCalled, isTrue);

      expect(res, equals('Response'));

      await sub.cancel();
    });

    test('sendRPCMessage with non-null mapper', () async {
      var callbackCalled = false;
      producer.setPushCallback((message) {
        callbackCalled = true;
      });

      final sub =
          MQClient.instance.fetchQueue('test-queue').listen((message) async {
        if (message.headers['type'] == 'RPC') {
          (message.headers['completer'] as Completer).complete('Response');
          return;
        }
      });

      final response = await producer.sendRPCMessage(
        processId: 'foo',
        args: {'key': 'value'},
        exchangeName: '',
        routingKey: 'test-queue',
        mapper: (data) => '$data-new',
      );

      expect(callbackCalled, isTrue);
      expect(response, equals('Response-new'));

      await sub.cancel();
    });
  });
}
