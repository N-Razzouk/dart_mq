import 'dart:developer';

import 'package:dart_mq/dart_mq.dart';

final class WorkerOne with ConsumerMixin {
  WorkerOne() {
    MQClient.instance.declareQueue('task_queue');
  }

  void startListening() => subscribe(
        queueId: 'task_queue',
        filter: (Object messagePayload) => messagePayload
            .toString()
            .split('')
            .where((String char) => char == '.')
            .length
            .isEven,
        callback: (Message message) {
          log('WorkerOne reacting to ${message.payload}');
        },
      );
}
