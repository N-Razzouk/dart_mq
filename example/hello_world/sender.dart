import 'package:dart_mq/dart_mq.dart';

final class Sender with Producer {
  Sender() {
    MQClient.instance.declareQueue('hello');
  }

  void sendGreeting({required String greeting}) => sendMessage(
        routingKey: 'hello',
        payload: greeting,
      );
}
