import 'package:dart_mq/src/core/constants/error_strings.dart';

/// The [ExchangeException] class represents a base exception related to
/// exchanges.
///
/// It is used to handle exceptions that may occur when working with exchanges,
/// such as when an exchange is not registered or when an invalid exchange type
/// is encountered.
///
/// Subclasses of [ExchangeException] can provide more specific information
/// about the nature of the exception.
abstract base class ExchangeException implements Exception {
  /// Creates a new [ExchangeException] with the specified error [message].
  ExchangeException(this.message);

  /// The error message associated with the exception.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The [ExchangeNotRegisteredException] class represents an exception that
/// occurs when an exchange is not registered.
///
/// This exception is thrown when attempting to perform operations on an
/// exchange that has not been registered.
final class ExchangeNotRegisteredException extends ExchangeException {
  /// Creates a new [ExchangeNotRegisteredException] instance with the
  /// specified [exchangeName].
  ExchangeNotRegisteredException(String exchangeName)
      : super(ExceptionStrings.exchangeNotRegistered(exchangeName));
}

/// The [InvalidExchangeTypeException] class represents an exception that occurs
/// when an invalid exchange type is encountered.
///
/// This exception is thrown when an operation encounters an exchange type that
/// is not recognized or supported.
final class InvalidExchangeTypeException extends ExchangeException {
  /// Creates a new [InvalidExchangeTypeException] instance.
  InvalidExchangeTypeException()
      : super(ExceptionStrings.invalidExchangeType());
}
