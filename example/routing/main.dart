import 'package:dart_mq/dart_mq.dart';

import 'debug_logger.dart';
import 'logger.dart';
import 'production_logger.dart';

void main() async {
  MQClient.initialize();

  DebugLogger().startListening();

  ProductionLogger().startListening();

  final logger = Logger();

  await logger.log(
    level: 'info',
    message: 'This is an info message',
  );

  await logger.log(
    level: 'warning',
    message: 'This is a warning message',
  );

  await logger.log(
    level: 'error',
    message: 'This is an error message',
  );
}
