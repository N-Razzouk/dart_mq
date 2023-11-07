import 'package:dart_mq/dart_mq.dart';

import 'task_manager.dart';
import 'worker_one.dart';
import 'worker_two.dart';

void main() async {
  MQClient.initialize();

  final workerOne = WorkerOne();

  final workerTwo = WorkerTwo();

  final taskManager = TaskManager();

  workerOne.startListening();

  workerTwo.startListening();

  taskManager
    ..sendTask(task: 'Hello..')
    ..sendTask(task: 'Hello...')
    ..sendTask(task: 'Hello....')
    ..sendTask(task: 'Hello.')
    ..sendTask(task: 'Hello.......')
    ..sendTask(task: 'Hello..');
}
