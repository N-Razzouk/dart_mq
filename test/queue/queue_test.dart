import 'package:dart_mq/dart_mq.dart';
import 'package:dart_mq/src/queue/queue.dart';
import 'package:test/test.dart';

void main() {
  group('Queue', () {
    test('Creating a Queue', () {
      // Arrange
      const queueId = 'my_queue_id';

      // Act
      final myQueue = Queue(queueId);

      // Assert
      expect(myQueue.id, equals(queueId));
      expect(myQueue.latestMessage, isNull);
    });

    test('Get dataStream from Queue', () {
      // Arrange
      const queueId = 'my_queue_id';
      final myQueue = Queue(queueId);

      // Act
      final dataStream = myQueue.dataStream;

      // Assert
      expect(dataStream, isNotNull);
    });

    test('Enqueue and Check Has Listeners', () {
      // Arrange
      const queueId = 'my_queue_id';
      final myQueue = Queue(queueId);
      final message = Message(
        headers: {'contentType': 'json', 'sender': 'Alice'},
        payload: {'text': 'Hello, World!'},
        timestamp: '2023-09-07T12:00:002',
      );

      // Act
      myQueue.enqueue(message);
      final hasListeners = myQueue.hasListeners();

      // Assert
      expect(myQueue.id, equals(queueId));
      expect(myQueue.latestMessage, equals(message));
      expect(hasListeners, isFalse); // No listeners by default
    });

    test('Queue equality', () {
      // Arrange
      final queue1 = Queue('queue_id_1');
      final queue2 = Queue('queue_id_2');
      final queue3 = Queue('queue_id_1'); // Same ID as queue1

      // Act & Assert
      expect(queue1, equals(queue3)); // Should be equal based on ID
      expect(
        queue1,
        isNot(equals(queue2)),
      ); // Should not be equal due to different IDs
    });

    test('Queue hashCode', () {
      // Arrange
      final queue1 = Queue('queue_id_1');
      final queue2 = Queue('queue_id_2');
      final queue3 = Queue('queue_id_1'); // Same ID as queue1

      // Act & Assert
      expect(queue1.hashCode, equals(queue3.hashCode));
      expect(queue1.hashCode, isNot(equals(queue2.hashCode)));
    });

    test('Queue dispose', () {
      // Arrange
      const queueId = 'my_queue_id';
      final myQueue = Queue(queueId);
      final message = Message(
        headers: {'contentType': 'json', 'sender': 'Alice'},
        payload: {'text': 'Hello, World!'},
        timestamp: '2023-09-07T12:00:002',
      );

      // Act
      myQueue
        ..enqueue(message)
        ..dispose();
      final hasListeners = myQueue.hasListeners();

      // Assert
      expect(myQueue.id, equals(queueId));
      expect(myQueue.latestMessage, equals(message));
      expect(hasListeners, isFalse);
    });
  });
}
