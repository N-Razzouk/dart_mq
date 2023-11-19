import 'package:dart_mq/dart_mq.dart';

import 'receiver.dart';
import 'sender.dart';

void main() async {
  MQClient.initialize();

  final sender = Sender();

  final receiver = Receiver()..listenToGreeting();

  sender.sendGreeting(greeting: 'Hello, World!');

  /// This line is because, well, the whole idea is built
  /// on asynchronous programming, so we need to wait for
  /// the stream to receive so that the listener can
  /// react appropriately.
  await Future.delayed(const Duration(milliseconds: 10));

  receiver.stopListening();
}
