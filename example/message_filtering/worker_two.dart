import 'dart:developer';

import 'package:dart_mq/dart_mq.dart';

final class WorkerTwo with Consumer {
  WorkerTwo() {
    MQClient.instance.declareQueue('task_queue');
  }

  void startListening() => subscribe(
        queueId: 'task_queue',
        filter: (Object messagePayload) =>
            messagePayload
                    .toString()
                    .split('')
                    .where((String char) => char == '.')
                    .length %
                2 !=
            0,
        callback: (Message message) {
          log('WorkerTwo reacting to ${message.payload}');
        },
      );
}
