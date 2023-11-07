import 'package:dart_mq/src/message/message.base.dart';

/// Represents a message with headers, payload, and an optional timestamp.
///
/// A [Message] is a specific type of message that extends the [BaseMessage]
/// class.
///
/// Example:
/// ```dart
/// final message = Message(
///   headers: {'contentType': 'json', 'sender': 'Alice'},
///   payload: {'text': 'Hello, World!'},
///   timestamp: '2023-09-07T12:00:002',
/// );
/// ```
class Message extends BaseMessage {
  /// Creates a new [Message] with the specified headers, payload, and
  /// timestamp.
  ///
  /// The [headers] parameter is a map that can contain additional information
  /// about the message. It is optional and defaults to an empty map if not
  /// provided.
  ///
  /// The [payload] parameter represents the main content of the message and is
  /// required.
  ///
  /// The [timestamp] parameter is an optional ISO 8601 formatted timestamp
  /// indicating when the message was created. If not provided, the current
  /// timestamp will be used.
  ///
  /// Example:
  /// ```dart
  /// final message = Message(
  ///   headers: {'contentType': 'json', 'sender': 'Alice'},
  ///   payload: {'text': 'Hello, World!'},
  ///   timestamp: '2023-09-07T12:00:002',
  /// );
  /// ```
  Message({
    required Object payload,
    Map<String, dynamic>? headers,
    String? timestamp,
  }) : super(
          headers,
          payload,
          timestamp ?? DateTime.now().toUtc().toIso8601String(),
        );

  /// Returns a human-readable string representation of the message.
  ///
  /// Example:
  /// ```dart
  /// final message = Message(
  ///   headers: {'contentType': 'json', 'sender': 'Alice'},
  ///   payload: {'text': 'Hello, World!'},
  ///   timestamp: '2023-09-07T12:00:002',
  /// );
  ///
  /// print(message.toString());
  /// // Output:
  /// // Message{
  /// //   headers: {contentType: json, sender: Alice},
  /// //   payload: {text: Hello, World!},
  /// //   timestamp: 2023-09-07T12:00:002,
  /// // }
  /// ```
  @override
  String toString() {
    return '''
Message{
      headers: $headers,
      payload: $payload,
      timestamp: $timestamp,
    }''';
  }
}
