import 'package:dart_mq/src/core/constants/error_strings.dart';

/// The [MQClientException] class represents a base exception related to the
/// MQClient.
///
/// It is used to handle exceptions that may occur when working with the
/// MQClient, such as when the MQClient is not initialized.
///
/// Subclasses of [MQClientException] can provide more specific information
/// about the nature of the exception.
abstract base class MQClientException implements Exception {
  /// Creates a new [MQClientException] with the specified error [message].
  MQClientException(this.message);

  /// The error message associated with the exception.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The [MQClientNotInitializedException] class represents an exception that
/// occurs when the MQClient is not initialized.
///
/// This exception is thrown when attempting to use the MQClient before it has
/// been properly initialized using the `MQClient.initialize()` method.
final class MQClientNotInitializedException extends MQClientException {
  /// Creates a new [MQClientNotInitializedException] instance.
  MQClientNotInitializedException()
      : super(ExceptionStrings.mqClientNotInitialized());
}
