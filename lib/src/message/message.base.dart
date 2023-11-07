/// Represents a base message with headers, payload, and an optional timestamp.
///
/// A [BaseMessage] is a fundamental unit of data used in various messaging
/// systems. It typically contains metadata in the form of headers, the actual
/// payload, and an optional timestamp indicating when the message was created.
///
/// The `headers` property is a map that can contain additional information
/// about the message, such as content type, sender, or any custom metadata.
///
/// The `payload` property stores the main content of the message. It can be
/// of any type, allowing flexibility in the data that can be transmitted.
///
/// The `timestamp` property, if provided, represents the time when the message
/// was created. It is formatted as an ISO 8601 string.
abstract class BaseMessage {
  /// Creates a new `BaseMessage` with the specified headers, payload, and
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
  /// indicating when the message was created. If not provided, it will be
  /// `null`.
  BaseMessage(
    Map<String, dynamic>? headers,
    this.payload,
    this.timestamp,
  ) : headers = headers ?? {};

  /// A map containing headers or metadata associated with the message.
  final Map<String, dynamic> headers;

  /// The main content of the message.
  final Object payload;

  /// An optional timestamp indicating when the message was created.
  final String? timestamp;
}
