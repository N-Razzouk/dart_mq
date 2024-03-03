import 'package:dart_mq/dart_mq.dart';

final class Sender with ProducerMixin {
  Sender() {
    MQClient.instance.declareQueue('hello');
  }

  Future<void> sendGreeting({required String greeting}) async => sendMessage(
        routingKey: 'hello',
        payload: greeting,
      );
}
