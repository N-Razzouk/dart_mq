import 'package:dart_mq/src/core/constants/error_strings.dart';

/// The [ConsumerException] class represents a base exception related to
/// consumers.
///
/// It is used to handle exceptions that may occur when working with consumers,
/// such as when a consumer is not registered, is already subscribed to a queue,
/// is not subscribed to a queue when expected, or has active subscriptions.
///
/// Subclasses of [ConsumerException] can provide more specific information
/// about the nature of the exception.
abstract base class ConsumerException implements Exception {
  /// Creates a new [ConsumerException] with the specified error [message].
  ConsumerException(this.message);

  /// The error message associated with the exception.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The [ConsumerNotRegisteredException] class represents an exception that
/// occurs when a consumer is not registered.
///
/// This exception is thrown when attempting to perform operations on a consumer
/// that has not been registered.
final class ConsumerNotRegisteredException extends ConsumerException {
  /// Creates a new [ConsumerNotRegisteredException] instance with the
  /// specified [consumer].
  ConsumerNotRegisteredException(String consumer)
      : super(ExceptionStrings.consumerNotRegistered(consumer));
}

/// The [ConsumerAlreadySubscribedException] class represents an exception that
/// occurs when a consumer is already subscribed to a queue.
///
/// This exception is thrown when attempting to subscribe a consumer to a queue
/// that it is already subscribed to.
final class ConsumerAlreadySubscribedException extends ConsumerException {
  /// Creates a new [ConsumerAlreadySubscribedException] instance with the
  /// specified [queue].
  ConsumerAlreadySubscribedException({
    required String consumer,
    required String queue,
  }) : super(ExceptionStrings.consumerAlreadySubscribed(consumer, queue));
}

/// The [ConsumerNotSubscribedException] class represents an exception that
/// occurs when a consumer is not subscribed to a queue when expected.
///
/// This exception is thrown when an operation expects a consumer to be
/// subscribed to a queue, but the consumer is not.
final class ConsumerNotSubscribedException extends ConsumerException {
  /// Creates a new [ConsumerNotSubscribedException] instance with the
  /// specified [queue].
  ConsumerNotSubscribedException({
    required String consumer,
    required String queue,
  }) : super(ExceptionStrings.consumerNotSubscribed(consumer, queue));
}

/// The [ConsumerHasSubscriptionsException] class represents an exception that
/// occurs when a consumer has active subscriptions.
///
/// This exception is thrown when an operation expects a consumer to have no
/// active subscriptions, but the consumer has active subscriptions.
final class ConsumerHasSubscriptionsException extends ConsumerException {
  /// Creates a new [ConsumerHasSubscriptionsException] instance with the
  /// specified [consumer].
  ConsumerHasSubscriptionsException(String consumer)
      : super(ExceptionStrings.consumerHasSubscriptions(consumer));
}
