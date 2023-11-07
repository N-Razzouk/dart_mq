import 'package:dart_mq/dart_mq.dart';
import 'package:test/test.dart';

void main() {
  group('BaseMessage', () {
    test('Creating a BaseMessage', () {
      // Arrange
      final headers = {'content-type': 'text/plain'};
      const payload = 'Hello, World!';
      const timestamp = '2023-09-07T12:00:002';

      // Act
      final baseMessage =
          Message(payload: payload, headers: headers, timestamp: timestamp);

      // Assert
      expect(baseMessage.headers, equals(headers));
      expect(baseMessage.payload, equals(payload));
      expect(baseMessage.timestamp, equals(timestamp));
    });

    test('Creating a BaseMessage without headers and timestamp', () {
      // Arrange
      const payload = 'Hello, World!';

      // Act
      final baseMessage = Message(
        payload: payload,
      );

      // Assert
      expect(baseMessage.headers, isEmpty);
      expect(baseMessage.payload, equals(payload));
      expect(baseMessage.timestamp, isNotNull);
    });

    test('toString function.', () {
      // Arrange
      final headers = {'content-type': 'text/plain'};
      const payload = 'Hello, World!';
      const timestamp = '2023-09-07T12:00:002';

      // Act
      final baseMessage =
          Message(payload: payload, headers: headers, timestamp: timestamp);

      // Assert
      expect(
        baseMessage.toString(),
        equals('''
Message{
      headers: $headers,
      payload: $payload,
      timestamp: $timestamp,
    }'''),
      );
    });
  });
}
