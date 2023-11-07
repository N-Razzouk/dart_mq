import 'package:dart_mq/dart_mq.dart';

final class Logger with Producer {
  Logger() {
    MQClient.instance.declareExchange(
      exchangeName: 'logs',
      exchangeType: ExchangeType.direct,
    );
  }

  Future<void> log({
    required String level,
    required String message,
  }) async {
    sendMessage(
      payload: message,
      exchangeName: 'logs',
      routingKey: level,
    );
  }
}
