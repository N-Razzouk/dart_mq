import 'dart:developer';

import 'package:dart_mq/dart_mq.dart';

final class DebugLogger with Consumer {
  DebugLogger() {
    MQClient.instance.declareExchange(
      exchangeName: 'logs',
      exchangeType: ExchangeType.direct,
    );
    _queueName = MQClient.instance.declareQueue('debug');
  }

  late final String _queueName;

  void startListening() {
    MQClient.instance.bindQueue(
      queueId: _queueName,
      exchangeName: 'logs',
      bindingKey: 'info',
    );
    MQClient.instance.bindQueue(
      queueId: _queueName,
      exchangeName: 'logs',
      bindingKey: 'warning',
    );
    MQClient.instance.bindQueue(
      queueId: _queueName,
      exchangeName: 'logs',
      bindingKey: 'error',
    );
    subscribe(
      queueId: _queueName,
      callback: (Message message) {
        log('Debug Logger recieved: ${message.payload}');
      },
    );
  }
}
