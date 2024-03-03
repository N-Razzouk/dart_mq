import 'package:dart_mq/dart_mq.dart';

final class TaskManager with ProducerMixin {
  TaskManager() {
    MQClient.instance.declareQueue('task_queue');
  }

  void sendTask({required String task}) => sendMessage(
        payload: task,
        routingKey: 'task_queue',
      );
}
