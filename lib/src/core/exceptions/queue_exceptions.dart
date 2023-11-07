import 'package:dart_mq/src/core/constants/error_strings.dart';

/// The [QueueException] class represents a base exception related to queues.
///
/// It is used to handle exceptions that may occur when working with queues,
/// such as when a queue is not registered or when there are subscribers to a
/// queue.
///
/// Subclasses of [QueueException] can provide more specific information about
/// the nature of the exception.
abstract class QueueException implements Exception {
  /// Creates a new [QueueException] with the specified error [message].
  QueueException(this.message);

  /// The error message associated with the exception.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The [QueueNotRegisteredException] class represents an exception that occurs
/// when a queue with a specific ID is not registered.
///
/// This exception is thrown when attempting to perform an operation on an
/// unregistered queue.
final class QueueNotRegisteredException extends QueueException {
  /// Creates a new [QueueNotRegisteredException] instance with the specified
  /// [queueId].
  QueueNotRegisteredException(String queueId)
      : super(ExceptionStrings.queueNotRegistered(queueId));
}

/// The [QueueHasSubscribersException] class represents an exception that occurs
/// when there are active subscribers to a queue.
///
/// This exception is thrown when attempting to delete a queue that still has
/// subscribers listening to it.
final class QueueHasSubscribersException extends QueueException {
  /// Creates a new [QueueHasSubscribersException] instance with the specified
  /// [queueId].
  QueueHasSubscribersException(String queueId)
      : super(ExceptionStrings.queueHasSubscribers(queueId));
}

/// The [QueueIdNullException] class represents an exception that occurs when
/// attempting to create a queue with a null name.
///
/// This exception is thrown when the name of the queue is not provided and is
/// null.
final class QueueIdNullException extends QueueException {
  /// Creates a new [QueueIdNullException] instance.
  QueueIdNullException() : super(ExceptionStrings.queueIdNull());
}
