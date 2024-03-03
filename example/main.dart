import 'package:dart_mq/dart_mq.dart';

import 'receiver.dart';
import 'sender.dart';

void main() async {
  MQClient.initialize();

  final sender = Sender();

  final receiver = Receiver()..listenToGreeting();

  await sender.sendGreeting(greeting: 'Hello, World!');

  receiver.stopListening();
}
