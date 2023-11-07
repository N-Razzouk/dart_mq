import 'dart:async';
import 'dart:developer';

import 'package:dart_mq/dart_mq.dart';

class ServiceTwo with Consumer {
  ServiceTwo() {
    MQClient.instance.declareExchange(
      exchangeName: 'ServiceRPC',
      exchangeType: ExchangeType.direct,
    );
    _queueName = MQClient.instance.declareQueue('two');
  }

  late final String _queueName;

  Future<void> startListening() async {
    MQClient.instance.bindQueue(
      queueId: _queueName,
      exchangeName: 'ServiceRPC',
      bindingKey: 'rpcBinding',
    );
    subscribe(
      queueId: _queueName,
      callback: (Message message) async {
        log('Service Two got message $message\n');
        if (message.headers['type'] == 'RPC') {
          switch (message.headers['processId']) {
            case 'foo':
              final data = await foo();
              final Completer completer =
                  message.headers['completer'] ?? (throw Exception());
              completer.complete(data);
            default:
          }
        }
      },
    );
  }

  Future<String> foo() async {
    // log('Service Two bar\n');
    await Future.delayed(const Duration(seconds: 2));
    return 'Hello, world!';
  }
}
