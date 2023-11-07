import 'dart:developer';

import 'package:dart_mq/dart_mq.dart';

final class Receiver with Consumer {
  Receiver() {
    MQClient.instance.declareQueue('hello');
  }

  void listenToGreeting() => subscribe(
        queueId: 'hello',
        callback: (Message message) {
          log('Received: ${message.payload}');
        },
      );

  void stopListening() => unsubscribe(queueId: 'hello');
}
