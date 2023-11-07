import 'package:dart_mq/src/core/exceptions/exceptions.dart';
import 'package:test/test.dart';

void main() {
  group('QueueException', () {
    test('QueueNotRegisteredException', () {
      final exception = QueueNotRegisteredException('my_queue_id');
      expect(exception.toString(), contains('QueueNotRegisteredException'));
      expect(
        exception.toString(),
        contains('Queue: my_queue_id is not registered'),
      );
    });

    test('QueueHasSubscribersException', () {
      final exception = QueueHasSubscribersException('my_queue_id');
      expect(exception.toString(), contains('QueueHasSubscribersException'));
      expect(
        exception.toString(),
        contains('Queue: my_queue_id has subscribers'),
      );
    });

    test('QueueIdNullException', () {
      final exception = QueueIdNullException();
      expect(exception.toString(), contains('QueueIdNullException'));
      expect(exception.toString(), contains("Queue name can't be null"));
    });
  });
}
