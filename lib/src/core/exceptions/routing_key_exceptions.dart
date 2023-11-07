import 'package:dart_mq/src/core/constants/error_strings.dart';

/// The [RoutingKeyException] class represents a base exception related to
/// routing key operations.
///
/// It is used to handle exceptions that may occur when working with routing
/// keys, which are used for message routing in message broker systems.
///
/// Subclasses of [RoutingKeyException] can provide more specific information
/// about the nature of the exception.
abstract class RoutingKeyException implements Exception {
  /// Creates a new [RoutingKeyException] with the specified error [message].
  RoutingKeyException(this.message);

  /// The error message associated with the exception.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The [RoutingKeyRequiredException] class represents an exception that occurs
/// when a routing key is required for a specific operation but is not provided.
///
/// This exception is thrown when an operation expects a routing key to be
/// provided, but it is missing.
final class RoutingKeyRequiredException extends RoutingKeyException {
  /// Creates a new [RoutingKeyRequiredException] instance.
  RoutingKeyRequiredException() : super(ExceptionStrings.routingKeyRequired());
}
