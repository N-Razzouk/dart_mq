import 'dart:developer';

import 'package:dart_mq/dart_mq.dart';

final class ProductionLogger with Consumer {
  ProductionLogger() {
    MQClient.instance.declareExchange(
      exchangeName: 'logs',
      exchangeType: ExchangeType.direct,
    );
    _queueName = MQClient.instance.declareQueue('production');
  }

  late final String _queueName;

  void startListening() {
    MQClient.instance.bindQueue(
      queueId: _queueName,
      exchangeName: 'logs',
      bindingKey: 'error',
    );
    subscribe(
      queueId: _queueName,
      callback: (Message message) {
        log('Production Logger recieved: ${message.payload}');
      },
    );
  }
}
