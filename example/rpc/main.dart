import 'package:dart_mq/dart_mq.dart';

import 'service_one.dart';
import 'service_two.dart';

void main() {
  MQClient.initialize();

  MQClient.instance.declareExchange(
    exchangeName: 'ServiceRPC',
    exchangeType: ExchangeType.direct,
  );

  final serviceOne = ServiceOne();

  ServiceTwo().startListening();

  serviceOne.requestFoo();
}
